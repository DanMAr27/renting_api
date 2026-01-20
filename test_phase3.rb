# frozen_string_literal: true

# Test script to verify Phase 3 services
puts "🧪 Testing Phase 3: Business Logic Services\n\n"

# Test 1: Number Generator
puts "1️⃣ Testing NumberGenerator..."
series = Renting::OrderSeries.first
generator = Renting::Orders::NumberGenerator.new(series)
order_number = generator.generate
puts "   ✅ Generated order number: #{order_number}\n\n"

# Test 2: Order Creator
puts "2️⃣ Testing OrderCreator..."
params = {
  company_id: Company.first.id,
  supplier_id: Supplier.first.id,
  order_series_id: Renting::OrderSeries.first.id,
  order_date: Date.current,
  expected_delivery_date: Date.current + 30.days,
  vehicle_spec: {
    vehicle_type_id: Renting::VehicleType.first.id,
    fuel_type: 'diesel',
    transmission: 'automatic',
    min_seats: 5,
    preferred_color: 'Black'
  },
  contract_condition: {
    duration_months: 36,
    annual_km: 20000,
    monthly_fee: 450.00
  },
  assignment: {
    usage_type: 'individual',
    driver_id: User.first.id,
    cost_center_id: CostCenter.first.id,
    department_id: Department.first.id
  },
  service_ids: [ Renting::Service.first.id ]
}

creator = Renting::Orders::Creator.new(params, User.first)
order = creator.call

if creator.success?
  puts "   ✅ Order created: #{order.order_number}"
  puts "   ✅ Vehicle spec created: #{order.vehicle_spec.fuel_type} #{order.vehicle_spec.transmission}"
  puts "   ✅ Contract condition created: #{order.contract_condition.monthly_fee} EUR/month"
  puts "   ✅ Assignment created: #{order.assignment.usage_type}"
  puts "   ✅ Services: #{order.services.count} service(s)\n\n"
else
  puts "   ❌ Errors: #{creator.errors.join(', ')}\n\n"
  exit 1
end

# Test 3: Authorization Policy
puts "3️⃣ Testing Authorization::Policy..."
policy = Renting::Authorization::Policy.new(order)
requires_auth = policy.requires_authorization?
puts "   ✅ Requires authorization: #{requires_auth} (monthly_fee: #{order.contract_condition.monthly_fee})\n\n"

# Test 4: State Machine
puts "4️⃣ Testing StateMachine..."
state_machine = Renting::Orders::StateMachine.new(order, User.first)
puts "   Current status: #{order.status}"
puts "   Allowed transitions: #{state_machine.allowed_transitions.join(', ')}"

if state_machine.can_transition_to?('pending_authorization')
  state_machine.transition_to!('pending_authorization', notes: 'Test transition')
  puts "   ✅ Transitioned to: #{order.reload.status}"
  puts "   ✅ Status history count: #{order.status_histories.count}\n\n"
else
  puts "   ❌ Cannot transition to pending_authorization\n\n"
  exit 1
end

# Test 5: Authorization Response Handler
puts "5️⃣ Testing Authorization::ResponseHandler..."
handler = Renting::Authorization::ResponseHandler.new(order)
handler.handle_approval
puts "   ✅ Order approved: #{order.reload.status}\n\n"

puts "🎉 All Phase 3 services working correctly!"
puts "\n📊 Final Order State:"
puts "   Order Number: #{order.order_number}"
puts "   Status: #{order.status}"
puts "   Status History: #{order.status_histories.count} records"
puts "   Monthly Fee: #{order.contract_condition.monthly_fee} EUR"
puts "   Vehicle Type: #{order.vehicle_spec.vehicle_type.name}"
