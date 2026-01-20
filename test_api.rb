# frozen_string_literal: true

# Test script to verify Phase 4: API Endpoints
require 'net/http'
require 'json'

puts "🧪 Testing Phase 4: API Endpoints\n\n"

BASE_URL = "http://localhost:3000/api/v1/renting"

def make_request(method, path, body = nil)
  uri = URI("#{BASE_URL}#{path}")

  case method
  when :get
    request = Net::HTTP::Get.new(uri)
  when :post
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = body.to_json if body
  end

  response = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(request)
  end

  JSON.parse(response.body) rescue response.body
end

# Test 1: GET /vehicle_types
puts "1️⃣ Testing GET /api/v1/renting/vehicle_types..."
begin
  response = make_request(:get, '/vehicle_types')
  puts "   ✅ Vehicle Types: #{response.size} types found"
  puts "   Example: #{response.first['name']}\n\n" if response.first
rescue => e
  puts "   ❌ Error: #{e.message}\n\n"
end

# Test 2: GET /services
puts "2️⃣ Testing GET /api/v1/renting/services..."
begin
  response = make_request(:get, '/services')
  puts "   ✅ Services: #{response.size} services found"
  puts "   Example: #{response.first['name']}\n\n" if response.first
rescue => e
  puts "   ❌ Error: #{e.message}\n\n"
end

# Test 3: GET /orders
puts "3️⃣ Testing GET /api/v1/renting/orders..."
begin
  response = make_request(:get, '/orders')
  puts "   ✅ Orders: #{response.size} orders found"
  if response.first
    puts "   Example: #{response.first['order_number']} - Status: #{response.first['status']}\n\n"
  end
rescue => e
  puts "   ❌ Error: #{e.message}\n\n"
end

# Test 4: POST /orders (Create new order)
puts "4️⃣ Testing POST /api/v1/renting/orders..."
begin
  order_data = {
    company_id: Company.first.id,
    supplier_id: Supplier.first.id,
    order_series_id: Renting::OrderSeries.first.id,
    expected_delivery_date: (Date.current + 30.days).to_s,
    vehicle_spec: {
      vehicle_type_id: Renting::VehicleType.first.id,
      fuel_type: 'electric',
      transmission: 'automatic',
      min_seats: 5,
      preferred_color: 'White'
    },
    contract_condition: {
      duration_months: 48,
      annual_km: 15000,
      monthly_fee: 550.00
    },
    assignment: {
      usage_type: 'collective',
      cost_center_id: CostCenter.first.id
    },
    service_ids: [ Renting::Service.first.id ]
  }

  response = make_request(:post, '/orders', order_data)
  if response['id']
    puts "   ✅ Order created: #{response['order_number']}"
    puts "   Status: #{response['status']}"
    puts "   Monthly fee: #{response['contract_condition']['monthly_fee']} EUR\n\n"
    @test_order_id = response['id']
  else
    puts "   ❌ Error: #{response}\n\n"
  end
rescue => e
  puts "   ❌ Error: #{e.message}\n\n"
end

# Test 5: POST /orders/:id/submit
if @test_order_id
  puts "5️⃣ Testing POST /api/v1/renting/orders/#{@test_order_id}/submit..."
  begin
    response = make_request(:post, "/orders/#{@test_order_id}/submit")
    puts "   ✅ #{response['message']}"
    puts "   New status: #{response['status']}\n\n"
  rescue => e
    puts "   ❌ Error: #{e.message}\n\n"
  end
end

puts "🎉 API testing completed!"
