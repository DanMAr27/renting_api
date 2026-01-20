# frozen_string_literal: true

# Test script to verify Authorization System
puts "🧪 Testing Authorization System\n\n"

# Test 1: Create order with 400 EUR (no authorization required)
puts "1️⃣ Testing order with 400 EUR (no authorization)..."
params_low = {
  company_id: Company.first.id,
  supplier_id: Supplier.first.id,
  order_series_id: Renting::OrderSeries.first.id,
  vehicle_spec: {
    vehicle_type_id: Renting::VehicleType.first.id,
    fuel_type: 'diesel',
    transmission: 'automatic',
    min_seats: 5
  },
  contract_condition: {
    duration_months: 36,
    annual_km: 15000,
    monthly_fee: 400.00
  },
  assignment: {
    usage_type: 'individual',
    driver_id: User.first.id
  }
}

creator = Renting::Orders::Creator.new(params_low, User.first)
order_low = creator.call

puts "   Order created: #{order_low.order_number}"

# Submit for authorization
request_creator = Renting::Authorization::RequestCreator.new(order_low)
auth_request = request_creator.call

if auth_request.nil?
  puts "   ✅ No authorization required (auto-approved)"
  puts "   Order status: #{order_low.reload.status}\n\n"
else
  puts "   ❌ Unexpected: authorization was required\n\n"
end

# Test 2: Create order with 600 EUR (requires 1 level - manager)
puts "2️⃣ Testing order with 600 EUR (requires manager approval)..."
params_mid = params_low.deep_dup
params_mid[:contract_condition][:monthly_fee] = 600.00

creator = Renting::Orders::Creator.new(params_mid, User.first)
order_mid = creator.call

puts "   Order created: #{order_mid.order_number}"

request_creator = Renting::Authorization::RequestCreator.new(order_mid)
auth_request_mid = request_creator.call

if auth_request_mid
  puts "   ✅ Authorization required"
  puts "   Max level: #{auth_request_mid.max_level}"
  puts "   Current level: #{auth_request_mid.current_level}"
  puts "   Order status: #{order_mid.reload.status}"

  # Manager approves
  manager = User.find_by(role: 'manager')
  processor = Authorization::ApprovalProcessor.new(auth_request_mid, manager, 'approved', 'Approved by manager')

  if processor.call
    puts "   ✅ Manager approved"
    puts "   Auth request status: #{auth_request_mid.reload.status}"
    puts "   Order status: #{order_mid.reload.status}\n\n"
  else
    puts "   ❌ Approval failed: #{processor.errors.join(', ')}\n\n"
  end
else
  puts "   ❌ Authorization was not created\n\n"
end

# Test 3: Create order with 1200 EUR (requires 2 levels - manager + admin)
puts "3️⃣ Testing order with 1200 EUR (requires manager + admin approval)..."
params_high = params_low.deep_dup
params_high[:contract_condition][:monthly_fee] = 1200.00

creator = Renting::Orders::Creator.new(params_high, User.first)
order_high = creator.call

puts "   Order created: #{order_high.order_number}"

request_creator = Renting::Authorization::RequestCreator.new(order_high)
auth_request_high = request_creator.call

if auth_request_high
  puts "   ✅ Authorization required"
  puts "   Max level: #{auth_request_high.max_level}"
  puts "   Current level: #{auth_request_high.current_level}"

  # Manager approves level 1
  manager = User.find_by(role: 'manager')
  processor = Authorization::ApprovalProcessor.new(auth_request_high, manager, 'approved', 'Approved by manager')

  if processor.call
    puts "   ✅ Manager approved (level 1)"
    puts "   Current level: #{auth_request_high.reload.current_level}"
    puts "   Auth status: #{auth_request_high.status}"
    puts "   Order status: #{order_high.reload.status}"

    # Admin approves level 2
    admin = User.find_by(role: 'admin')
    processor2 = Authorization::ApprovalProcessor.new(auth_request_high, admin, 'approved', 'Approved by admin')

    if processor2.call
      puts "   ✅ Admin approved (level 2)"
      puts "   Auth status: #{auth_request_high.reload.status}"
      puts "   Order status: #{order_high.reload.status}\n\n"
    else
      puts "   ❌ Admin approval failed: #{processor2.errors.join(', ')}\n\n"
    end
  else
    puts "   ❌ Manager approval failed: #{processor.errors.join(', ')}\n\n"
  end
else
  puts "   ❌ Authorization was not created\n\n"
end

# Test 4: Test rejection
puts "4️⃣ Testing rejection flow..."
params_reject = params_low.deep_dup
params_reject[:contract_condition][:monthly_fee] = 700.00

creator = Renting::Orders::Creator.new(params_reject, User.first)
order_reject = creator.call

request_creator = Renting::Authorization::RequestCreator.new(order_reject)
auth_request_reject = request_creator.call

if auth_request_reject
  manager = User.find_by(role: 'manager')
  processor = Authorization::ApprovalProcessor.new(auth_request_reject, manager, 'rejected', 'Budget exceeded')

  if processor.call
    puts "   ✅ Order rejected by manager"
    puts "   Auth status: #{auth_request_reject.reload.status}"
    puts "   Order status: #{order_reject.reload.status}\n\n"
  else
    puts "   ❌ Rejection failed\n\n"
  end
end

puts "🎉 Authorization System tests completed!"
puts "\n📊 Summary:"
puts "   Authorization Rules: #{AuthorizationRule.count}"
puts "   Authorization Requests: #{AuthorizationRequest.count}"
puts "   Authorization Approvals: #{AuthorizationApproval.count}"
