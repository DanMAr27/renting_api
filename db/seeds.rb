# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database..."

# Companies
puts "Creating companies..."
company1 = Company.find_or_create_by!(tax_id: "B12345678") do |c|
  c.name = "ACME Corporation"
  c.address = "Calle Principal 123, Madrid"
  c.active = true
end

company2 = Company.find_or_create_by!(tax_id: "B87654321") do |c|
  c.name = "Tech Solutions SL"
  c.address = "Av. Tecnología 456, Barcelona"
  c.active = true
end

puts "✅ Created #{Company.count} companies"

# Suppliers
puts "Creating suppliers..."
supplier1 = Supplier.find_or_create_by!(name: "Renting Fleet SA") do |s|
  s.tax_id = "A11111111"
  s.contact_email = "contacto@rentingfleet.com"
  s.contact_phone = "+34 900 123 456"
  s.active = true
end

supplier2 = Supplier.find_or_create_by!(name: "AutoLease Europe") do |s|
  s.tax_id = "A22222222"
  s.contact_email = "info@autolease.eu"
  s.contact_phone = "+34 900 654 321"
  s.active = true
end

puts "✅ Created #{Supplier.count} suppliers"

# Users
puts "Creating users..."
admin = User.find_or_create_by!(email: "admin@acme.com") do |u|
  u.name = "Admin User"
  u.role = "admin"
  u.encrypted_password = "password_hash"
  u.active = true
end

manager = User.find_or_create_by!(email: "manager@acme.com") do |u|
  u.name = "Manager User"
  u.role = "manager"
  u.encrypted_password = "password_hash"
  u.active = true
end

user = User.find_or_create_by!(email: "user@acme.com") do |u|
  u.name = "Regular User"
  u.role = "user"
  u.encrypted_password = "password_hash"
  u.active = true
end

puts "✅ Created #{User.count} users"

# Cost Centers
puts "Creating cost centers..."
cc1 = CostCenter.find_or_create_by!(code: "CC001") do |cc|
  cc.name = "Departamento Comercial"
  cc.description = "Centro de coste para el equipo comercial"
  cc.active = true
end

cc2 = CostCenter.find_or_create_by!(code: "CC002") do |cc|
  cc.name = "Departamento IT"
  cc.description = "Centro de coste para tecnología"
  cc.active = true
end

puts "✅ Created #{CostCenter.count} cost centers"

# Departments
puts "Creating departments..."
dept1 = Department.find_or_create_by!(code: "SALES") do |d|
  d.name = "Ventas"
  d.description = "Departamento de ventas"
  d.active = true
end

dept2 = Department.find_or_create_by!(code: "IT") do |d|
  d.name = "Tecnología"
  d.description = "Departamento de IT"
  d.active = true
end

puts "✅ Created #{Department.count} departments"

# Divisions
puts "Creating divisions..."
div1 = Division.find_or_create_by!(code: "MADRID") do |d|
  d.name = "División Madrid"
  d.description = "Oficina central Madrid"
  d.active = true
end

div2 = Division.find_or_create_by!(code: "BCN") do |d|
  d.name = "División Barcelona"
  d.description = "Oficina Barcelona"
  d.active = true
end

puts "✅ Created #{Division.count} divisions"

# Order Series
puts "Creating order series..."
series = Renting::OrderSeries.find_or_create_by!(code: "RENT_2026") do |s|
  s.prefix = "RP"
  s.current_counter = 0
  s.active = true
end

puts "✅ Created #{Renting::OrderSeries.count} order series"

# Vehicle Types
puts "Creating vehicle types..."
types = [
  { code: "SUV", name: "SUV", description: "Sport Utility Vehicle" },
  { code: "SEDAN", name: "Sedán", description: "Vehículo sedán" },
  { code: "COMPACT", name: "Compacto", description: "Vehículo compacto" },
  { code: "VAN", name: "Furgoneta", description: "Furgoneta comercial" },
  { code: "SPORT", name: "Deportivo", description: "Vehículo deportivo" }
]

types.each do |type_data|
  Renting::VehicleType.find_or_create_by!(code: type_data[:code]) do |vt|
    vt.name = type_data[:name]
    vt.description = type_data[:description]
    vt.active = true
  end
end

puts "✅ Created #{Renting::VehicleType.count} vehicle types"

# Services
puts "Creating services..."
services = [
  { code: "MAINT", name: "Mantenimiento", description: "Servicio de mantenimiento integral" },
  { code: "TIRES", name: "Neumáticos", description: "Cambio de neumáticos" },
  { code: "INS", name: "Seguro", description: "Seguro a todo riesgo" },
  { code: "ASSIST", name: "Asistencia", description: "Asistencia en carretera 24/7" }
]

services.each do |service_data|
  Renting::Service.find_or_create_by!(code: service_data[:code]) do |s|
    s.name = service_data[:name]
    s.description = service_data[:description]
    s.active = true
  end
end

puts "✅ Created #{Renting::Service.count} services"

# Authorization Rules
puts "Creating authorization rules..."

# Rule 1: Orders > 500 EUR require Manager approval
AuthorizationRule.find_or_create_by!(
  authorizable_type: 'Renting::Order',
  approval_level: 1
) do |rule|
  rule.name = 'Manager approval for orders > 500 EUR'
  rule.condition_field = 'contract_condition.monthly_fee'
  rule.condition_operator = 'greater_than'
  rule.condition_value = 500
  rule.required_role = 'manager'
  rule.active = true
end

# Rule 2: Orders > 1000 EUR require additional Admin approval
AuthorizationRule.find_or_create_by!(
  authorizable_type: 'Renting::Order',
  approval_level: 2
) do |rule|
  rule.name = 'Admin approval for orders > 1000 EUR'
  rule.condition_field = 'contract_condition.monthly_fee'
  rule.condition_operator = 'greater_than'
  rule.condition_value = 1000
  rule.required_role = 'admin'
  rule.active = true
end

puts "✅ Created #{AuthorizationRule.count} authorization rules"

# Orders
puts "Creating specific orders (Renting)..."

# Helpers
acme = Company.find_by(name: "ACME Corporation")
renting_fleet = Supplier.find_by(name: "Renting Fleet SA")
admin = User.find_by(email: "admin@acme.com")
user = User.find_by(email: "user@acme.com")
cc = CostCenter.first
dept = Department.find_by(code: "SALES") || Department.first
div = Division.find_by(code: "MADRID") || Division.first
series = Renting::OrderSeries.find_by(code: "RENT_2026")
suv = Renting::VehicleType.find_by(code: "SUV")
sedan = Renting::VehicleType.find_by(code: "SEDAN")
services_all = Renting::Service.all

# 1. Order in 'created' status (Low value)
order1 = Renting::Order.create!(
  order_number: Renting::Orders::NumberGenerator.new(series).generate,
  company: acme,
  supplier: renting_fleet,
  order_series: series,
  created_by: user,
  status: "created",
  order_date: Date.current,
  expected_delivery_date: Date.current + 30.days
)

Renting::OrderVehicleSpec.create!(
  order: order1,
  vehicle_type: sedan,
  fuel_type: "hybrid",
  transmission: "automatic",
  min_seats: 5,
  preferred_color: "Blanco"
)

Renting::OrderContractCondition.create!(
  order: order1,
  duration_months: 48,
  annual_km: 20000,
  monthly_fee: 450.0 # < 500, simple
)

Renting::OrderAssignment.create!(
  order: order1,
  usage_type: "individual",
  cost_center_id: cc.id,
  department_id: dept.id,
  division_id: div.id,
  driver_id: user.id
)

services_all.take(2).each do |s|
  Renting::OrderService.create!(order: order1, service: s, monthly_price: 10.0)
end

puts "  -> Created Order #{order1.order_number} (Status: #{order1.status})"

# 2. Order in 'pending_authorization' (High value > 500)
order2 = Renting::Order.create!(
  order_number: Renting::Orders::NumberGenerator.new(series).generate,
  company: acme,
  supplier: renting_fleet,
  order_series: series,
  created_by: user,
  status: "created",
  order_date: Date.current,
  expected_delivery_date: Date.current + 45.days
)

Renting::OrderVehicleSpec.create!(
  order: order2,
  vehicle_type: suv,
  fuel_type: "electric",
  transmission: "automatic",
  min_seats: 5,
  preferred_color: "Azul Metalizado"
)

Renting::OrderContractCondition.create!(
  order: order2,
  duration_months: 36,
  annual_km: 15000,
  monthly_fee: 650.0 # Requires Manager approval
)

Renting::OrderAssignment.create!(
  order: order2,
  usage_type: "individual",
  cost_center_id: cc.id,
  department_id: dept.id,
  division_id: div.id,
  driver_id: user.id
)

# Submit to auth
Renting::Authorization::RequestCreator.new(order2).call
puts "  -> Created Order #{order2.order_number} (Status: #{order2.reload.status})"

# 3. Order in 'authorized' (High value > 1000, Admin approved)
order3 = Renting::Order.create!(
  order_number: Renting::Orders::NumberGenerator.new(series).generate,
  company: acme,
  supplier: renting_fleet,
  order_series: series,
  created_by: user,
  status: "created",
  order_date: Date.current - 5.days,
  expected_delivery_date: Date.current + 25.days
)

Renting::OrderVehicleSpec.create!(
  order: order3,
  vehicle_type: suv,
  fuel_type: "diesel",
  transmission: "manual",
  min_seats: 7,
  preferred_color: "Negro"
)

Renting::OrderContractCondition.create!(
  order: order3,
  duration_months: 48,
  annual_km: 30000,
  monthly_fee: 1200.0 # Requires Admin approval
)

Renting::OrderAssignment.create!(
  order: order3,
  usage_type: "collective",
  cost_center_id: cc.id,
  department_id: dept.id,
  division_id: div.id
)

# Submit & Approve
Renting::Authorization::RequestCreator.new(order3).call
auth_req = order3.authorization_request

# Simulate Admin approval (Processor should handle logic)
Authorization::ApprovalProcessor.new(auth_req, admin, "approved", "Approved by Seed").call
puts "  -> Created Order #{order3.order_number} (Status: #{order3.reload.status})"

puts "\n🎉 Seeding completed successfully!"
puts "📊 Summary:"
puts "  - Companies: #{Company.count}"
puts "  - Suppliers: #{Supplier.count}"
puts "  - Users: #{User.count}"
puts "  - Cost Centers: #{CostCenter.count}"
puts "  - Departments: #{Department.count}"
puts "  - Divisions: #{Division.count}"
puts "  - Order Series: #{Renting::OrderSeries.count}"
puts "  - Vehicle Types: #{Renting::VehicleType.count}"
puts "  - Services: #{Renting::Service.count}"
puts "  - Authorization Rules: #{AuthorizationRule.count}"
puts "  - Orders: #{Renting::Order.count}"
