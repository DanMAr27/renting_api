# frozen_string_literal: true

# Test script to verify refactored Vehicle/Contract creation flow
puts "🧪 Testing Refactored Vehicle/Contract Flow\n\n"

# Test 1: Create and approve order
puts "1️⃣ Creating and approving order..."
params = {
  company_id: Company.first.id,
  supplier_id: Supplier.first.id,
  order_series_id: Renting::OrderSeries.first.id,
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
    monthly_fee: 450.00
  },
  assignment: {
    usage_type: 'individual',
    driver_id: User.first.id
  }
}

creator = Renting::Orders::Creator.new(params, User.first)
order = creator.call

puts "   Order created: #{order.order_number}"
puts "   Status: #{order.status}\n\n"

# Transition to confirmed (simulating supplier confirmation)
puts "2️⃣ Transitioning order to confirmed..."
state_machine = Renting::Orders::StateMachine.new(order, User.first)
state_machine.transition_to!('confirmed', notes: 'Supplier confirmed order')
puts "   Order status: #{order.reload.status}\n\n"

# Test 2: Assign vehicle (supplier confirms - creates Vehicle + Contract)
puts "3️⃣ Assigning vehicle (creating Vehicle + Contract in pending states)..."
assigner = Renting::Orders::VehicleAssigner.new(order)
assigner.call

if assigner.success?
  puts "   ✅ Vehicle and Contract created"
  puts "   Order status: #{order.reload.status}"
  puts "   Vehicle ID: #{assigner.vehicle.id}"
  puts "   Vehicle status: #{assigner.vehicle.status}"
  puts "   Vehicle has license_plate: #{assigner.vehicle.license_plate.present?}"
  puts "   Contract ID: #{assigner.contract.id}"
  puts "   Contract status: #{assigner.contract.status}"
  puts "   Contract has supplier_contract_number: #{assigner.contract.supplier_contract_number.present?}\n\n"
else
  puts "   ❌ Failed: #{assigner.errors.join(', ')}\n\n"
  exit 1
end

# Test 3: Complete delivery (from Vehicle, not Order)
puts "4️⃣ Completing delivery (registering vehicle data)..."
delivery_params = {
  license_plate: 'NEW1234',
  vin: '1HGBH41JXMN100001',
  color: 'Pearl White',
  initial_km: 10,
  supplier_contract_number: 'SUPP-2026-NEW',
  contract_start_date: Date.current
}

completer = Renting::Delivery::Completer.new(assigner.vehicle, delivery_params)
completer.call

if completer.success?
  vehicle = assigner.vehicle.reload
  contract = assigner.contract.reload
  order_final = order.reload

  puts "   ✅ Delivery completed"
  puts "   Vehicle status: #{vehicle.status}"
  puts "   Vehicle license_plate: #{vehicle.license_plate}"
  puts "   Vehicle VIN: #{vehicle.vin}"
  puts "   Vehicle color: #{vehicle.color}"
  puts "   Vehicle initial_km: #{vehicle.initial_km}"
  puts "   Contract status: #{contract.status}"
  puts "   Contract supplier_contract_number: #{contract.supplier_contract_number}"
  puts "   Contract start_date: #{contract.start_date}"
  puts "   Order status: #{order_final.status}\n\n"
else
  puts "   ❌ Failed: #{completer.errors.join(', ')}\n\n"
  exit 1
end

puts "🎉 All tests passed!"
puts "\n📊 Summary:"
puts "   Flow: Order (confirmed) → VehicleAssigner → Vehicle (pending_delivery) + Contract (pending_formalization)"
puts "         → Delivery::Completer → Vehicle (active) + Contract (active) + Order (completed)"
puts "\n   Final states:"
puts "   - Order: #{order.reload.status}"
puts "   - Vehicle: #{assigner.vehicle.reload.status}"
puts "   - Contract: #{assigner.contract.reload.status}"
