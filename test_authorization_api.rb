require_relative 'config/environment'
require 'net/http'
require 'json'

class AuthorizationApiTester
  BASE_URL = 'http://localhost:3001/api/v1'

  def initialize
    @admin = User.find_by(role: 'admin')
    @manager = User.find_by(role: 'manager')
    @employee = User.find_by(role: 'user')
    puts "Loaded users:"
    puts "Admin: #{@admin&.id}"
    puts "Manager: #{@manager&.id}"
    puts "Employee (User role): #{@employee&.id}"

    if @admin.nil? || @manager.nil? || @employee.nil?
      puts "ERROR: Missing required users. Check seeds."
      exit 1
    end
  end

  def run
    puts "\n" + "="*80
    puts "TESTING AUTHORIZATION SYSTEM API"
    puts "="*80

    test_authorization_rules_api
    test_authorization_requests_api
    test_approval_flow

    puts "\n" + "="*80
    puts "ALL TESTS COMPLETED"
    puts "="*80
  end

  private

  def test_authorization_rules_api
    puts "\n--- Testing Authorization Rules API ---"

    # 1. List all rules
    puts "\n1. GET /api/v1/authorization/rules"
    response = get_request('/authorization/rules', @admin.id)
    puts "   Status: #{response.code}"
    rules = JSON.parse(response.body)
    puts "   Found #{rules.size} rules"

    # 2. Get specific rule
    if rules.any?
      rule_id = rules.first['id']
      puts "\n2. GET /api/v1/authorization/rules/#{rule_id}"
      response = get_request("/authorization/rules/#{rule_id}", @admin.id)
      puts "   Status: #{response.code}"
      rule = JSON.parse(response.body)
      puts "   Rule: #{rule['name']}"
    end

    # 3. Create new rule (admin only)
    puts "\n3. POST /api/v1/authorization/rules (as admin)"
    new_rule = {
      authorizable_type: 'Renting::Order',
      name: 'Test Rule - High Value Orders',
      condition_field: 'monthly_fee',
      condition_operator: 'greater_than',
      condition_value: 2000,
      required_role: 'admin',
      approval_level: 3,
      active: true
    }
    response = post_request('/authorization/rules', new_rule, @admin.id)
    puts "   Status: #{response.code}"
    if response.code == '201'
      created_rule = JSON.parse(response.body)
      puts "   Created rule ID: #{created_rule['id']}"
      @test_rule_id = created_rule['id']
    end

    # 4. Try to create rule as employee (should fail)
    puts "\n4. POST /api/v1/authorization/rules (as employee - should fail)"
    response = post_request('/authorization/rules', new_rule, @employee.id)
    if response.code == '403'
      puts "   Status: #{response.code} (SUCCESS)"
    else
      puts "   Status: #{response.code} (FAILURE: Expected 403)"
      puts "   Body: #{response.body}"
    end

    # 5. Update rule
    if @test_rule_id
      puts "\n5. PUT /api/v1/authorization/rules/#{@test_rule_id}"
      update_data = { active: false }
      response = put_request("/authorization/rules/#{@test_rule_id}", update_data, @admin.id)
      puts "   Status: #{response.code}"
    end

    # 6. Delete rule
    if @test_rule_id
      puts "\n6. DELETE /api/v1/authorization/rules/#{@test_rule_id}"
      response = delete_request("/authorization/rules/#{@test_rule_id}", @admin.id)
      puts "   Status: #{response.code}"
    end
  end

  def test_authorization_requests_api
    puts "\n--- Testing Authorization Requests API ---"

    # 1. List all authorization requests
    puts "\n1. GET /api/v1/authorization/requests"
    response = get_request('/authorization/requests', @admin.id)
    puts "   Status: #{response.code}"
    requests = JSON.parse(response.body)
    puts "   Found #{requests.size} authorization requests"

    # 2. List pending requests for manager
    puts "\n2. GET /api/v1/authorization/requests/pending (as manager)"
    response = get_request('/authorization/requests/pending', @manager.id)
    puts "   Status: #{response.code}"
    pending = JSON.parse(response.body)
    puts "   Manager has #{pending.size} pending requests to approve"

    # 3. Get specific request details
    if requests.any?
      request_id = requests.first['id']
      puts "\n3. GET /api/v1/authorization/requests/#{request_id}"
      response = get_request("/authorization/requests/#{request_id}", @admin.id)
      puts "   Status: #{response.code}"
      request_detail = JSON.parse(response.body)
      puts "   Request status: #{request_detail['status']}"
      puts "   Current level: #{request_detail['current_level']}/#{request_detail['max_level']}"
    end
  end

  def test_approval_flow
    puts "\n--- Testing Complete Approval Flow ---"

    # Create a new order that requires authorization
    puts "\n1. Creating order with monthly_fee = 600 EUR (requires manager approval)"

    company = Company.first
    supplier = Supplier.first
    vehicle_type = Renting::VehicleType.first

    order_data = {
      company_id: company.id,
      supplier_id: supplier.id,
      vehicle_spec_attributes: {
        vehicle_type_id: vehicle_type.id,
        brand: 'Test Brand',
        model: 'Test Model',
        fuel_type: 'gasoline',
        transmission: 'automatic'
      },
      contract_condition_attributes: {
        duration_months: 36,
        monthly_fee: 600,
        included_km_per_year: 15000,
        excess_km_fee: 0.15
      },
      assignment_attributes: {
        assignee_type: 'employee',
        assignee_name: 'Test Employee'
      }
    }

    creator = Renting::Orders::Creator.new(order_data, @employee)
    order = creator.call

    puts "   Order created: #{order.order_number}"
    puts "   Order status: #{order.status}"

    # Check if authorization request was created
    auth_request = AuthorizationRequest.find_by(authorizable: order)

    if auth_request
      puts "\n2. Authorization request created automatically"
      puts "   Request ID: #{auth_request.id}"
      puts "   Status: #{auth_request.status}"
      puts "   Max level: #{auth_request.max_level}"

      # Manager approves
      puts "\n3. POST /api/v1/authorization/requests/#{auth_request.id}/approve (as manager)"
      approval_data = { notes: 'Approved via API test' }
      response = post_request("/authorization/requests/#{auth_request.id}/approve", approval_data, @manager.id)
      puts "   Status: #{response.code}"

      if response.code == '200'
        result = JSON.parse(response.body)
        puts "   Request status after approval: #{result['status']}"

        # Check order status
        order.reload
        puts "   Order status after approval: #{order.status}"
      end
    else
      puts "\n   No authorization request created (monthly_fee might be below threshold)"
    end

    # Create order with higher amount (requires 2 levels)
    puts "\n4. Creating order with monthly_fee = 1200 EUR (requires manager + admin approval)"

    order_data[:contract_condition_attributes][:monthly_fee] = 1200
    creator = Renting::Orders::Creator.new(order_data, @employee)
    order2 = creator.call

    puts "   Order created: #{order2.order_number}"

    auth_request2 = AuthorizationRequest.find_by(authorizable: order2)

    if auth_request2
      puts "   Authorization request ID: #{auth_request2.id}"
      puts "   Max level required: #{auth_request2.max_level}"

      # Manager approves level 1
      puts "\n5. Manager approves level 1"
      response = post_request("/authorization/requests/#{auth_request2.id}/approve", {}, @manager.id)
      puts "   Status: #{response.code}"

      auth_request2.reload
      puts "   Current level: #{auth_request2.current_level}"
      puts "   Request status: #{auth_request2.status}"

      # Admin approves level 2
      if auth_request2.pending?
        puts "\n6. Admin approves level 2"
        response = post_request("/authorization/requests/#{auth_request2.id}/approve", {}, @admin.id)
        puts "   Status: #{response.code}"

        auth_request2.reload
        puts "   Request status: #{auth_request2.status}"

        order2.reload
        puts "   Order status: #{order2.status}"
      end
    end
  end

  # HTTP Helper Methods

  def get_request(path, user_id)
    uri = URI("#{BASE_URL}#{path}")
    request = Net::HTTP::Get.new(uri)
    request['X-User-Id'] = user_id.to_s
    request['Content-Type'] = 'application/json'

    Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end
  end

  def post_request(path, data, user_id)
    uri = URI("#{BASE_URL}#{path}")
    request = Net::HTTP::Post.new(uri)
    request['X-User-Id'] = user_id.to_s
    request['Content-Type'] = 'application/json'
    request.body = data.to_json

    Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end
  end

  def put_request(path, data, user_id)
    uri = URI("#{BASE_URL}#{path}")
    request = Net::HTTP::Put.new(uri)
    request['X-User-Id'] = user_id.to_s
    request['Content-Type'] = 'application/json'
    request.body = data.to_json

    Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end
  end

  def delete_request(path, user_id)
    uri = URI("#{BASE_URL}#{path}")
    request = Net::HTTP::Delete.new(uri)
    request['X-User-Id'] = user_id.to_s
    request['Content-Type'] = 'application/json'

    Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end
  end
end

# Run tests
tester = AuthorizationApiTester.new
tester.run
