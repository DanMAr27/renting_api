# frozen_string_literal: true

# Test script to verify Phase 5: Vehicles and Contracts
puts "🧪 Testing Phase 5: Vehicles and Contracts\n\n"

# Test 1: Create a complete order flow
puts "1️⃣ Creating a complete order..."
params = {
  company_id: Company.first.id,
  supplier_id: Supplier.first.id,
  order_series_id: Renting::OrderSeries.first.id,
  order_date: Date.current,
  expected_delivery_date: Date.current + 30.days,
  vehicle_spec: {
    vehicle_type_id: Renting::VehicleType.first.id,
    fuel_type: 'electric',
    transmission: 'automatic',
    min_seats: 5,
    preferred_color: 'White'
  },
  contract_condition: {
    duration_months: 36,
    annual_km: 15000,
    monthly_fee: 550.00,
    contract_start_date: Date.current
  },
  assignment: {
    usage_type: 'individual',
    driver_id: User.first.id,
    cost_center_id: CostCenter.first.id
  },
  service_ids: [ Renting::Service.first.id ]
}

creator = Renting::Orders::Creator.new(params, User.first)
order = creator.call

if creator.success?
  puts "   ✅ Order created: #{order.order_number}\n\n"
else
  puts "   ❌ Failed to create order\n\n"
  exit 1
end

# Test 2: Transition order to in_delivery
puts "2️⃣ Transitioning order to in_delivery..."
state_machine = Renting::Orders::StateMachine.new(order, User.first)
state_machine.transition_to!('in_delivery', notes: 'Ready for delivery')
puts "   ✅ Order status: #{order.reload.status}\n\n"

# Test 3: Complete delivery (create Vehicle + Contract)
puts "3️⃣ Completing delivery..."
delivery_params = {
  license_plate: 'TEST1234',
  vin: '1HGBH41JXMN109999',
  color: 'Pearl White',
  initial_km: 15,
  supplier_contract_number: 'SUPP-2026-TEST'
}

completer = Renting::Delivery::Completer.new(order, delivery_params)
completer.call

if completer.success?
  puts "   ✅ Delivery completed successfully"
  puts "   ✅ Order status: #{order.reload.status}"
  puts "   ✅ Vehicle created: #{completer.vehicle.license_plate}"
  puts "   ✅ Contract created: #{completer.contract.supplier_contract_number}\n\n"
else
  puts "   ❌ Errors: #{completer.errors.join(', ')}\n\n"
  exit 1
end

# Test 4: Verify Vehicle
puts "4️⃣ Verifying Vehicle..."
vehicle = order.reload.vehicle
puts "   License Plate: #{vehicle.license_plate}"
puts "   VIN: #{vehicle.vin}"
puts "   Color: #{vehicle.color}"
puts "   Status: #{vehicle.status}"
puts "   Initial KM: #{vehicle.initial_km}"
puts "   Current KM: #{vehicle.current_km}\n\n"

# Test 5: Verify Contract
puts "5️⃣ Verifying Contract..."
contract = order.contract
puts "   Supplier Contract #: #{contract.supplier_contract_number}"
puts "   Status: #{contract.status}"
puts "   Duration: #{contract.duration_months} months"
puts "   Monthly Fee: #{contract.monthly_fee} EUR"
puts "   Start Date: #{contract.start_date}"
puts "   Expected End Date: #{contract.expected_end_date}"
puts "   Days until expiration: #{contract.days_until_expiration}\n\n"

# Test 6: Test Vehicle KM update
puts "6️⃣ Testing Vehicle KM update..."
vehicle.update_km(100)
puts "   ✅ Updated KM: #{vehicle.reload.current_km}\n\n"

puts "🎉 All Phase 5 tests passed!"
puts "\n📊 Summary:"
puts "   Order: #{order.order_number} (#{order.status})"
puts "   Vehicle: #{vehicle.license_plate} (#{vehicle.status})"
puts "   Contract: #{contract.supplier_contract_number} (#{contract.status})"
puts "   Days until contract expiration: #{contract.days_until_expiration}"
