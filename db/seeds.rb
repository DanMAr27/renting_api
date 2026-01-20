# frozen_string_literal: true

# ============================================================================
# COMPREHENSIVE SEED DATA FOR RENTING API
# ============================================================================
# This file populates all tables with abundant test data covering different
# scenarios and business logic flows for comprehensive testing.
# ============================================================================

# ============================================================================
# CLEANUP: Delete all existing data
# ============================================================================
puts "🗑️  Cleaning existing data..."

# Delete in reverse order of dependencies to avoid foreign key constraints
Renting::VehicleReturn.delete_all
Renting::VehicleDelivery.delete_all
AuthorizationApproval.delete_all
AuthorizationRequest.delete_all
Renting::OrderStatusHistory.delete_all
Renting::OrderDeliveryHistory.delete_all
Renting::OrderService.delete_all
Renting::OrderAssignment.delete_all
Renting::OrderContractCondition.delete_all
Renting::OrderVehicleSpec.delete_all
Renting::Contract.delete_all
Renting::Vehicle.delete_all
Renting::Order.delete_all
AuthorizationRule.delete_all
Renting::Service.delete_all
Renting::VehicleType.delete_all
Renting::OrderSeries.delete_all
Division.delete_all
Department.delete_all
CostCenter.delete_all
User.delete_all
Supplier.delete_all
Company.delete_all

puts "✅ Data cleaned successfully"
puts ""

puts "🌱 Starting comprehensive database seeding..."
puts "=" * 80

# ============================================================================
# SECTION 1: MASTER DATA
# ============================================================================
puts "\n📋 SECTION 1: Creating Master Data..."

# Companies
puts "  → Creating companies..."
companies = []
companies << Company.find_or_create_by!(tax_id: "B12345678") do |c|
  c.name = "ACME Corporation"
  c.address = "Calle Principal 123, Madrid"
  c.active = true
end

companies << Company.find_or_create_by!(tax_id: "B87654321") do |c|
  c.name = "Tech Solutions SL"
  c.address = "Av. Tecnología 456, Barcelona"
  c.active = true
end

companies << Company.find_or_create_by!(tax_id: "B11223344") do |c|
  c.name = "Global Logistics SA"
  c.address = "Paseo de la Castellana 789, Madrid"
  c.active = true
end

puts "    ✅ Created #{Company.count} companies"

# Suppliers
puts "  → Creating suppliers..."
suppliers = []
suppliers << Supplier.find_or_create_by!(name: "Renting Fleet SA") do |s|
  s.tax_id = "A11111111"
  s.contact_email = "contacto@rentingfleet.com"
  s.contact_phone = "+34 900 123 456"
  s.active = true
end

suppliers << Supplier.find_or_create_by!(name: "AutoLease Europe") do |s|
  s.tax_id = "A22222222"
  s.contact_email = "info@autolease.eu"
  s.contact_phone = "+34 900 654 321"
  s.active = true
end

suppliers << Supplier.find_or_create_by!(name: "Premium Car Rental") do |s|
  s.tax_id = "A33333333"
  s.contact_email = "sales@premiumcar.es"
  s.contact_phone = "+34 900 111 222"
  s.active = true
end

suppliers << Supplier.find_or_create_by!(name: "EcoFleet Solutions") do |s|
  s.tax_id = "A44444444"
  s.contact_email = "contact@ecofleet.com"
  s.contact_phone = "+34 900 333 444"
  s.active = true
end

puts "    ✅ Created #{Supplier.count} suppliers"

# Users
puts "  → Creating users..."
users = {}

users[:admin] = User.find_or_create_by!(email: "admin@acme.com") do |u|
  u.name = "Admin User"
  u.role = "admin"
  u.encrypted_password = "password_hash"
  u.active = true
end

users[:manager1] = User.find_or_create_by!(email: "manager@acme.com") do |u|
  u.name = "Manager User"
  u.role = "manager"
  u.encrypted_password = "password_hash"
  u.active = true
end

users[:manager2] = User.find_or_create_by!(email: "manager2@acme.com") do |u|
  u.name = "Fleet Manager"
  u.role = "manager"
  u.encrypted_password = "password_hash"
  u.active = true
end

users[:user1] = User.find_or_create_by!(email: "user@acme.com") do |u|
  u.name = "Regular User"
  u.role = "user"
  u.encrypted_password = "password_hash"
  u.active = true
end

users[:user2] = User.find_or_create_by!(email: "user2@acme.com") do |u|
  u.name = "Sales User"
  u.role = "user"
  u.encrypted_password = "password_hash"
  u.active = true
end

# Drivers
users[:driver1] = User.find_or_create_by!(email: "driver1@acme.com") do |u|
  u.name = "Juan García"
  u.role = "user"
  u.encrypted_password = "password_hash"
  u.active = true
end

users[:driver2] = User.find_or_create_by!(email: "driver2@acme.com") do |u|
  u.name = "María López"
  u.role = "user"
  u.encrypted_password = "password_hash"
  u.active = true
end

users[:driver3] = User.find_or_create_by!(email: "driver3@acme.com") do |u|
  u.name = "Carlos Martínez"
  u.role = "user"
  u.encrypted_password = "password_hash"
  u.active = true
end

users[:driver4] = User.find_or_create_by!(email: "driver4@acme.com") do |u|
  u.name = "Ana Rodríguez"
  u.role = "user"
  u.encrypted_password = "password_hash"
  u.active = true
end

users[:driver5] = User.find_or_create_by!(email: "driver5@acme.com") do |u|
  u.name = "Pedro Sánchez"
  u.role = "user"
  u.encrypted_password = "password_hash"
  u.active = true
end

puts "    ✅ Created #{User.count} users"

# Cost Centers
puts "  → Creating cost centers..."
cost_centers = []
cost_centers << CostCenter.find_or_create_by!(code: "CC001") do |cc|
  cc.name = "Departamento Comercial"
  cc.description = "Centro de coste para el equipo comercial"
  cc.active = true
end

cost_centers << CostCenter.find_or_create_by!(code: "CC002") do |cc|
  cc.name = "Departamento IT"
  cc.description = "Centro de coste para tecnología"
  cc.active = true
end

cost_centers << CostCenter.find_or_create_by!(code: "CC003") do |cc|
  cc.name = "Departamento Logística"
  cc.description = "Centro de coste para logística"
  cc.active = true
end

cost_centers << CostCenter.find_or_create_by!(code: "CC004") do |cc|
  cc.name = "Departamento Marketing"
  cc.description = "Centro de coste para marketing"
  cc.active = true
end

cost_centers << CostCenter.find_or_create_by!(code: "CC005") do |cc|
  cc.name = "Dirección General"
  cc.description = "Centro de coste para dirección"
  cc.active = true
end

puts "    ✅ Created #{CostCenter.count} cost centers"

# Departments
puts "  → Creating departments..."
departments = []
departments << Department.find_or_create_by!(code: "SALES") do |d|
  d.name = "Ventas"
  d.description = "Departamento de ventas"
  d.active = true
end

departments << Department.find_or_create_by!(code: "IT") do |d|
  d.name = "Tecnología"
  d.description = "Departamento de IT"
  d.active = true
end

departments << Department.find_or_create_by!(code: "LOG") do |d|
  d.name = "Logística"
  d.description = "Departamento de logística"
  d.active = true
end

departments << Department.find_or_create_by!(code: "MKT") do |d|
  d.name = "Marketing"
  d.description = "Departamento de marketing"
  d.active = true
end

departments << Department.find_or_create_by!(code: "HR") do |d|
  d.name = "Recursos Humanos"
  d.description = "Departamento de RRHH"
  d.active = true
end

departments << Department.find_or_create_by!(code: "FIN") do |d|
  d.name = "Finanzas"
  d.description = "Departamento financiero"
  d.active = true
end

puts "    ✅ Created #{Department.count} departments"

# Divisions
puts "  → Creating divisions..."
divisions = []
divisions << Division.find_or_create_by!(code: "MADRID") do |d|
  d.name = "División Madrid"
  d.description = "Oficina central Madrid"
  d.active = true
end

divisions << Division.find_or_create_by!(code: "BCN") do |d|
  d.name = "División Barcelona"
  d.description = "Oficina Barcelona"
  d.active = true
end

divisions << Division.find_or_create_by!(code: "VAL") do |d|
  d.name = "División Valencia"
  d.description = "Oficina Valencia"
  d.active = true
end

divisions << Division.find_or_create_by!(code: "SEV") do |d|
  d.name = "División Sevilla"
  d.description = "Oficina Sevilla"
  d.active = true
end

puts "    ✅ Created #{Division.count} divisions"

# ============================================================================
# SECTION 2: RENTING CONFIGURATION
# ============================================================================
puts "\n⚙️  SECTION 2: Creating Renting Configuration..."

# Order Series
puts "  → Creating order series..."
series_2026 = Renting::OrderSeries.find_or_create_by!(code: "RENT_2026") do |s|
  s.prefix = "RP"
  s.current_counter = 0
  s.active = true
end

series_2025 = Renting::OrderSeries.find_or_create_by!(code: "RENT_2025") do |s|
  s.prefix = "RP"
  s.current_counter = 150
  s.active = false
end

puts "    ✅ Created #{Renting::OrderSeries.count} order series"

# Vehicle Types
puts "  → Creating vehicle types..."
vehicle_types = {}
[
  { code: "SUV", name: "SUV", description: "Sport Utility Vehicle" },
  { code: "SEDAN", name: "Sedán", description: "Vehículo sedán" },
  { code: "COMPACT", name: "Compacto", description: "Vehículo compacto" },
  { code: "VAN", name: "Furgoneta", description: "Furgoneta comercial" },
  { code: "SPORT", name: "Deportivo", description: "Vehículo deportivo" }
].each do |type_data|
  vehicle_types[type_data[:code].downcase.to_sym] = Renting::VehicleType.find_or_create_by!(code: type_data[:code]) do |vt|
    vt.name = type_data[:name]
    vt.description = type_data[:description]
    vt.active = true
  end
end

puts "    ✅ Created #{Renting::VehicleType.count} vehicle types"

# Services
puts "  → Creating services..."
services = []
[
  { code: "MAINT", name: "Mantenimiento", description: "Servicio de mantenimiento integral" },
  { code: "TIRES", name: "Neumáticos", description: "Cambio de neumáticos" },
  { code: "INS", name: "Seguro", description: "Seguro a todo riesgo" },
  { code: "ASSIST", name: "Asistencia", description: "Asistencia en carretera 24/7" },
  { code: "FUEL", name: "Tarjeta Combustible", description: "Tarjeta de combustible" },
  { code: "GPS", name: "GPS", description: "Sistema de navegación GPS" },
  { code: "WINTER", name: "Neumáticos Invierno", description: "Neumáticos de invierno" },
  { code: "WASH", name: "Lavado", description: "Servicio de lavado mensual" }
].each do |service_data|
  services << Renting::Service.find_or_create_by!(code: service_data[:code]) do |s|
    s.name = service_data[:name]
    s.description = service_data[:description]
    s.active = true
  end
end

puts "    ✅ Created #{Renting::Service.count} services"

# ============================================================================
# SECTION 3: AUTHORIZATION RULES
# ============================================================================
puts "\n🔐 SECTION 3: Creating Authorization Rules..."

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

puts "    ✅ Created #{AuthorizationRule.count} authorization rules"

# ============================================================================
# SECTION 4: ORDERS - ALL SCENARIOS
# ============================================================================
puts "\n📦 SECTION 4: Creating Orders (All Scenarios)..."

orders = []

# Helper to create complete order
def create_order(params)
  order = Renting::Order.create!(
    order_number: Renting::Orders::NumberGenerator.new(params[:series]).generate,
    company: params[:company],
    supplier: params[:supplier],
    order_series: params[:series],
    created_by: params[:created_by],
    order_date: params[:order_date] || Date.current,
    expected_delivery_date: params[:expected_delivery_date] || (Date.current + 30.days),
    is_renewal: params[:is_renewal] || false,
    notes: params[:notes]
  )

  # Vehicle Spec
  Renting::OrderVehicleSpec.create!(
    order: order,
    vehicle_type: params[:vehicle_type],
    fuel_type: params[:fuel_type],
    transmission: params[:transmission],
    min_seats: params[:min_seats] || 5,
    preferred_color: params[:preferred_color],
    environmental_label: params[:environmental_label]
  )

  # Contract Condition
  Renting::OrderContractCondition.create!(
    order: order,
    duration_months: params[:duration_months],
    annual_km: params[:annual_km],
    monthly_fee: params[:monthly_fee],
    initial_payment: params[:initial_payment],
    deposit: params[:deposit]
  )

  # Assignment
  Renting::OrderAssignment.create!(
    order: order,
    usage_type: params[:usage_type] || "individual",
    cost_center: params[:cost_center],
    department: params[:department],
    division: params[:division],
    driver_id: params[:driver_id]
  )

  # Services
  params[:services]&.each do |service|
    Renting::OrderService.create!(
      order: order,
      service: service,
      monthly_price: rand(10.0..50.0).round(2)
    )
  end

  order
end

# ============================================================================
# ORDER SCENARIO GROUP A: Authorization Workflow
# ============================================================================
puts "  → Creating Authorization Workflow Orders..."

# 1. Order in 'created' - Low value, no authorization needed
orders << create_order(
  series: series_2026,
  company: companies[0],
  supplier: suppliers[0],
  created_by: users[:user1],
  status: "created",
  vehicle_type: vehicle_types[:sedan],
  fuel_type: "hybrid",
  transmission: "automatic",
  preferred_color: "Blanco",
  environmental_label: "ECO",
  duration_months: 48,
  annual_km: 20000,
  monthly_fee: 450.0,
  initial_payment: 0,
  deposit: 500,
  cost_center: cost_centers[0],
  department: departments[0],
  division: divisions[0],
  driver_id: users[:driver1].id,
  services: services.sample(2),
  notes: "Pedido básico sin necesidad de autorización"
)

# 2. Order in 'pending_authorization' - Requires manager approval
order_pending_auth = create_order(
  series: series_2026,
  company: companies[0],
  supplier: suppliers[1],
  created_by: users[:user2],
  status: "created",
  order_date: Date.current - 2.days,
  vehicle_type: vehicle_types[:suv],
  fuel_type: "electric",
  transmission: "automatic",
  preferred_color: "Azul Metalizado",
  environmental_label: "CERO",
  duration_months: 36,
  annual_km: 15000,
  monthly_fee: 650.0,
  initial_payment: 1000,
  deposit: 800,
  cost_center: cost_centers[1],
  department: departments[1],
  division: divisions[0],
  driver_id: users[:driver2].id,
  services: services.sample(3),
  notes: "SUV eléctrico premium"
)
# Manually transition to pending_authorization
order_pending_auth.submit_authorization!
orders << order_pending_auth

# 3. Order in 'authorized' - High value, admin approved
order_authorized = create_order(
  series: series_2026,
  company: companies[0],
  supplier: suppliers[2],
  created_by: users[:user1],
  status: "created",
  order_date: Date.current - 5.days,
  vehicle_type: vehicle_types[:suv],
  fuel_type: "diesel",
  transmission: "automatic",
  preferred_color: "Negro",
  environmental_label: "C",
  duration_months: 48,
  annual_km: 30000,
  monthly_fee: 1200.0,
  initial_payment: 2000,
  deposit: 1500,
  cost_center: cost_centers[4],
  department: departments[0],
  division: divisions[0],
  driver_id: users[:driver3].id,
  usage_type: "collective",
  services: services.sample(4),
  notes: "Vehículo para dirección general"
)
# Manually transition to authorized
order_authorized.submit_authorization!
order_authorized.authorize!
orders << order_authorized

# 4. Order in 'rejected' - Authorization denied
order_rejected = create_order(
  series: series_2026,
  company: companies[1],
  supplier: suppliers[0],
  created_by: users[:user2],
  status: "created",
  order_date: Date.current - 7.days,
  vehicle_type: vehicle_types[:sport],
  fuel_type: "gasoline",
  transmission: "manual",
  preferred_color: "Rojo",
  environmental_label: "B",
  duration_months: 24,
  annual_km: 10000,
  monthly_fee: 1500.0,
  initial_payment: 3000,
  deposit: 2000,
  cost_center: cost_centers[3],
  department: departments[3],
  division: divisions[1],
  driver_id: users[:driver4].id,
  services: services.sample(2),
  notes: "Deportivo de alta gama"
)
# Manually transition to rejected
order_rejected.submit_authorization!
order_rejected.reject!
orders << order_rejected

# 5. Order in 'cancelled'
order_cancelled = create_order(
  series: series_2026,
  company: companies[0],
  supplier: suppliers[1],
  created_by: users[:user1],
  status: "created",
  order_date: Date.current - 10.days,
  vehicle_type: vehicle_types[:compact],
  fuel_type: "hybrid",
  transmission: "automatic",
  preferred_color: "Gris",
  environmental_label: "ECO",
  duration_months: 36,
  annual_km: 15000,
  monthly_fee: 380.0,
  initial_payment: 0,
  deposit: 400,
  cost_center: cost_centers[0],
  department: departments[0],
  division: divisions[0],
  driver_id: users[:driver5].id,
  services: services.sample(2),
  notes: "Cancelado por cambio de necesidades"
)
order_cancelled.cancel!
orders << order_cancelled

# ============================================================================
# ORDER SCENARIO GROUP B: Supplier Workflow
# ============================================================================
puts "  → Creating Supplier Workflow Orders..."

# 6. Order in 'pending_supplier_confirmation'
order_pending_supplier = create_order(
  series: series_2026,
  company: companies[0],
  supplier: suppliers[3],
  created_by: users[:user2],
  order_date: Date.current - 15.days,
  vehicle_type: vehicle_types[:van],
  fuel_type: "diesel",
  transmission: "manual",
  preferred_color: "Blanco",
  environmental_label: "C",
  duration_months: 60,
  annual_km: 40000,
  monthly_fee: 550.0,
  initial_payment: 500,
  deposit: 600,
  cost_center: cost_centers[2],
  department: departments[2],
  division: divisions[0],
  usage_type: "collective",
  services: services.sample(3),
  notes: "Furgoneta para logística"
)
  # Manually transition through states for seed data
  begin
    puts "    → DEBUG: Transitioning pending_supplier order #{order_pending_supplier.order_number}"
    order_pending_supplier.submit_authorization!
    puts "      - Submitted auth"
    order_pending_supplier.authorize!
    puts "      - Authorized"
    order_pending_supplier.reload.send_to_supplier!
    puts "      - Sent to supplier"
  rescue => e
    puts "    ❌ ERROR transitioning pending_supplier order: #{e.message}"
    puts e.backtrace.join("\n")
  end
  orders << order_pending_supplier

# 7. Order in 'confirmed' - Ready for delivery
order_confirmed = create_order(
  series: series_2026,
  company: companies[0],
  supplier: suppliers[0],
  created_by: users[:user1],
  order_date: Date.current - 20.days,
  vehicle_type: vehicle_types[:sedan],
  fuel_type: "diesel",
  transmission: "automatic",
  preferred_color: "Plata",
  environmental_label: "C",
  duration_months: 48,
  annual_km: 25000,
  monthly_fee: 520.0,
  initial_payment: 800,
  deposit: 700,
  cost_center: cost_centers[0],
  department: departments[0],
  division: divisions[1],
  driver_id: users[:driver1].id,
  services: services.sample(4),
  notes: "Confirmado por proveedor, listo para entrega"
)
  # Manually transition through states for seed data
  begin
    puts "    → DEBUG: Transitioning confirmed order #{order_confirmed.order_number}"
    order_confirmed.submit_authorization!
    puts "      - Submitted auth"
    order_confirmed.authorize!
    puts "      - Authorized"
    order_confirmed.reload.send_to_supplier!
    puts "      - Sent to supplier"
    order_confirmed.confirm_by_supplier!
    puts "      - Confirmed by supplier"
  rescue => e
    puts "    ❌ ERROR transitioning confirmed order: #{e.message}"
    puts e.backtrace.join("\n")
  end
  orders << order_confirmed

# ============================================================================
# ORDER SCENARIO GROUP C: Completed Orders with Vehicles
# ============================================================================
puts "  → Creating Completed Orders with Vehicles..."

# Helper to create vehicle and contract
def create_vehicle_and_contract(order, params)
  vehicle = Renting::Vehicle.create!(
    order: order,
    vehicle_type: order.vehicle_spec.vehicle_type,
    license_plate: params[:license_plate],
    vin: params[:vin],
    fuel_type: order.vehicle_spec.fuel_type,
    transmission: order.vehicle_spec.transmission,
    color: params[:color] || order.vehicle_spec.preferred_color,
    delivery_date: params[:delivery_date],
    initial_km: params[:initial_km],
    current_km: params[:current_km]
  )

  contract = Renting::Contract.create!(
    order: order,
    vehicle: vehicle,
    supplier: order.supplier,
    company: order.company,
    supplier_contract_number: params[:supplier_contract_number],
    duration_months: order.contract_condition.duration_months,
    annual_km: order.contract_condition.annual_km,
    monthly_fee: order.contract_condition.monthly_fee,
    start_date: params[:start_date],
    expected_end_date: params[:expected_end_date]
  )

  { vehicle: vehicle, contract: contract, target_vehicle_status: params[:vehicle_status], target_contract_status: params[:contract_status] }
end

# 8-12. Orders in 'finished' with vehicles in various states
finished_orders_data = [
  {
    order_date: Date.current - 180.days,
    vehicle_type: vehicle_types[:sedan],
    fuel_type: "diesel",
    transmission: "automatic",
    preferred_color: "Negro",
    monthly_fee: 480.0,
    duration_months: 48,
    annual_km: 20000,
    license_plate: "1234ABC",
    vin: "VIN1234567890ABCD1",
    delivery_date: Date.current - 150.days,
    initial_km: 10,
    current_km: 25000,
    vehicle_status: "active",
    contract_status: "active",
    start_date: Date.current - 150.days,
    driver: users[:driver1]
  },
  {
    order_date: Date.current - 200.days,
    vehicle_type: vehicle_types[:suv],
    fuel_type: "hybrid",
    transmission: "automatic",
    preferred_color: "Blanco",
    monthly_fee: 620.0,
    duration_months: 36,
    annual_km: 15000,
    license_plate: "5678DEF",
    vin: "VIN1234567890ABCD2",
    delivery_date: Date.current - 170.days,
    initial_km: 5,
    current_km: 18000,
    vehicle_status: "active",
    contract_status: "active",
    start_date: Date.current - 170.days,
    driver: users[:driver2]
  },
  {
    order_date: Date.current - 220.days,
    vehicle_type: vehicle_types[:compact],
    fuel_type: "gasoline",
    transmission: "manual",
    preferred_color: "Rojo",
    monthly_fee: 350.0,
    duration_months: 48,
    annual_km: 15000,
    license_plate: "9012GHI",
    vin: "VIN1234567890ABCD3",
    delivery_date: Date.current - 190.days,
    initial_km: 15,
    current_km: 22000,
    vehicle_status: "immobilized",
    contract_status: "active",
    start_date: Date.current - 190.days,
    driver: users[:driver3]
  },
  {
    order_date: Date.current - 240.days,
    vehicle_type: vehicle_types[:van],
    fuel_type: "diesel",
    transmission: "manual",
    preferred_color: "Blanco",
    monthly_fee: 580.0,
    duration_months: 60,
    annual_km: 40000,
    license_plate: "3456JKL",
    vin: "VIN1234567890ABCD4",
    delivery_date: Date.current - 210.days,
    initial_km: 20,
    current_km: 35000,
    vehicle_status: "active",
    contract_status: "active",
    start_date: Date.current - 210.days,
    driver: nil
  },
  {
    order_date: Date.current - 260.days,
    vehicle_type: vehicle_types[:sedan],
    fuel_type: "electric",
    transmission: "automatic",
    preferred_color: "Azul",
    monthly_fee: 720.0,
    duration_months: 36,
    annual_km: 12000,
    license_plate: "7890MNO",
    vin: "VIN1234567890ABCD5",
    delivery_date: Date.current - 230.days,
    initial_km: 8,
    current_km: 15000,
    vehicle_status: "active",
    contract_status: "active",
    start_date: Date.current - 230.days,
    driver: users[:driver4]
  }
]

finished_orders_data.each_with_index do |data, index|
  order = create_order(
    series: series_2025,
    company: companies[index % companies.length],
    supplier: suppliers[index % suppliers.length],
    created_by: users[:user1],
    status: "created",
    order_date: data[:order_date],
    expected_delivery_date: data[:order_date] + 30.days,
    vehicle_type: data[:vehicle_type],
    fuel_type: data[:fuel_type],
    transmission: data[:transmission],
    preferred_color: data[:preferred_color],
    environmental_label: "ECO",
    duration_months: data[:duration_months],
    annual_km: data[:annual_km],
    monthly_fee: data[:monthly_fee],
    initial_payment: 500,
    deposit: 600,
    cost_center: cost_centers[index % cost_centers.length],
    department: departments[index % departments.length],
    division: divisions[index % divisions.length],
    driver_id: data[:driver]&.id,
    usage_type: data[:driver] ? "individual" : "collective",
    services: services.sample(3),
    notes: "Pedido completado con vehículo entregado"
  )

  begin
    puts "    → DEBUG: Transitioning finished order #{order.order_number}"
    # Manually transition through states for seed data
    order.submit_authorization!
    order.authorize!
    order.reload.send_to_supplier!
    order.confirm_by_supplier!
    order.complete!
    puts "      - Completed successfully"
  rescue => e
    puts "    ❌ ERROR transitioning finished order #{order.order_number}: #{e.message}"
    puts e.backtrace.join("\n")
  end

  expected_end = data[:start_date] + data[:duration_months].months
  result = create_vehicle_and_contract(order, {
    license_plate: data[:license_plate],
    vin: data[:vin],
    color: data[:preferred_color],
    delivery_date: data[:delivery_date],
    initial_km: data[:initial_km],
    current_km: data[:current_km],
    vehicle_status: data[:vehicle_status],
    contract_status: data[:contract_status],
    start_date: data[:start_date],
    expected_end_date: expected_end,
    supplier_contract_number: "SC-#{series_2025.prefix}-#{1000 + index}"
  })

  # Transition vehicle to correct state
  if data[:vehicle_status] == "active"
    result[:vehicle].deliver!
  elsif data[:vehicle_status] == "immobilized"
    result[:vehicle].deliver!
    result[:vehicle].immobilize!
  end

  # Transition contract to active
  if data[:contract_status] == "active"
    result[:contract].activate!
  end

  orders << order
end

# ============================================================================
# Additional scenarios: Vehicles pending delivery
# ============================================================================
puts "  → Creating Orders with Vehicles Pending Delivery..."

3.times do |i|
  order = create_order(
    series: series_2026,
    company: companies[i % companies.length],
    supplier: suppliers[i % suppliers.length],
    created_by: users[:user2],
    order_date: Date.current - (25 + i).days,
    vehicle_type: [ vehicle_types[:sedan], vehicle_types[:suv], vehicle_types[:compact] ][i],
    fuel_type: [ "diesel", "hybrid", "electric" ][i],
    transmission: "automatic",
    preferred_color: [ "Gris", "Verde", "Naranja" ][i],
    environmental_label: "ECO",
    duration_months: 48,
    annual_km: 20000,
    monthly_fee: 500.0 + (i * 50),
    initial_payment: 500,
    deposit: 600,
    cost_center: cost_centers[i],
    department: departments[i],
    division: divisions[i % divisions.length],
    driver_id: [ users[:driver5], users[:driver1], users[:driver2] ][i].id,
    services: services.sample(2),
    notes: "Vehículo confirmado, pendiente de entrega"
  )

  # Manually transition through states for seed data
  begin
    puts "    → DEBUG: Transitioning pending_delivery order #{order.order_number}"
    order.submit_authorization!
    order.authorize!
    order.reload.send_to_supplier!
    order.confirm_by_supplier!
    order.complete!
    puts "      - Completed successfully"
  rescue => e
    puts "    ❌ ERROR transitioning pending_delivery order #{order.order_number}: #{e.message}"
    puts e.backtrace.join("\n")
  end

  create_vehicle_and_contract(order, {
    license_plate: "PD#{1000 + i}XYZ",
    vin: "VINPENDING#{10 + i}ABCD",
    delivery_date: nil,
    initial_km: 0,
    current_km: 0,
    vehicle_status: "pending_delivery",
    contract_status: "pending_signature",
    start_date: nil,
    expected_end_date: nil,
    supplier_contract_number: "SC-PEND-#{1000 + i}"
  })

  orders << order
end

# ============================================================================
# Scenarios: Vehicles pending return
# ============================================================================
puts "  → Creating Orders with Vehicles Pending Return..."

2.times do |i|
  order = create_order(
    series: series_2025,
    company: companies[0],
    supplier: suppliers[i],
    created_by: users[:user1],

    order_date: Date.current - 400.days,
    vehicle_type: [ vehicle_types[:sedan], vehicle_types[:suv] ][i],
    fuel_type: [ "diesel", "gasoline" ][i],
    transmission: "automatic",
    preferred_color: [ "Negro", "Blanco" ][i],
    environmental_label: "C",
    duration_months: 36,
    annual_km: 20000,
    monthly_fee: 450.0,
    initial_payment: 500,
    deposit: 600,
    cost_center: cost_centers[0],
    department: departments[0],
    division: divisions[0],
    driver_id: [ users[:driver3], users[:driver4] ][i].id,
    services: services.sample(3),
    notes: "Contrato próximo a vencer, devolución iniciada"
  )

  # Manually transition through states for seed data
  begin
    puts "    → DEBUG: Transitioning pending_return order #{order.order_number}"
    order.submit_authorization!
    order.authorize!
    order.reload.send_to_supplier!
    order.confirm_by_supplier!
    order.complete!
    puts "      - Completed successfully"
  rescue => e
    puts "    ❌ ERROR transitioning pending_return order #{order.order_number}: #{e.message}"
    puts e.backtrace.join("\n")
  end

  start_date = Date.current - 370.days
  expected_end = start_date + 36.months

  result = create_vehicle_and_contract(order, {
    license_plate: "PR#{2000 + i}ABC",
    vin: "VINRETURN#{20 + i}ABCD",
    delivery_date: start_date,
    initial_km: 10,
    current_km: 45000 + (i * 5000),
    vehicle_status: "pending_return",
    contract_status: "pending_closure",
    start_date: start_date,
    expected_end_date: expected_end,
    supplier_contract_number: "SC-RET-#{2000 + i}"
  })

  begin
    result[:vehicle].deliver!
    result[:vehicle].initiate_return!
    result[:contract].activate!
    result[:contract].initiate_closure!

    # Set termination data
    result[:contract].update!(
      termination_type: i == 0 ? "expiration" : "early",
      end_action: "return_vehicle",
      termination_request_date: Date.current - 10.days
    )
  rescue => e
    puts "    ❌ ERROR transitioning pending_return details for order #{order.order_number}: #{e.message}"
    puts e.backtrace.join("\n")
  end

  orders << order
end

# ============================================================================
# Scenarios: Inactive vehicles (returned)
# ============================================================================
puts "  → Creating Orders with Inactive Vehicles..."

3.times do |i|
  order = create_order(
    series: series_2025,
    company: companies[i % companies.length],
    supplier: suppliers[i % suppliers.length],
    created_by: users[:user1],

    order_date: Date.current - 500.days,
    vehicle_type: [ vehicle_types[:compact], vehicle_types[:sedan], vehicle_types[:van] ][i],
    fuel_type: [ "gasoline", "diesel", "hybrid" ][i],
    transmission: [ "manual", "automatic", "automatic" ][i],
    preferred_color: [ "Rojo", "Azul", "Verde" ][i],
    environmental_label: "B",
    duration_months: 36,
    annual_km: 15000,
    monthly_fee: 400.0 + (i * 30),
    initial_payment: 400,
    deposit: 500,
    cost_center: cost_centers[i],
    department: departments[i],
    division: divisions[i % divisions.length],
    driver_id: [ users[:driver5], users[:driver1], users[:driver2] ][i].id,
    services: services.sample(2),
    notes: "Contrato finalizado, vehículo devuelto"
  )

  # Manually transition through states for seed data
  begin
    puts "    → DEBUG: Transitioning inactive order #{order.order_number}"
    order.submit_authorization!
    order.authorize!
    order.reload.send_to_supplier!
    order.confirm_by_supplier!
    order.complete!
    puts "      - Completed successfully"
  rescue => e
    puts "    ❌ ERROR transitioning inactive order #{order.order_number}: #{e.message}"
    puts e.backtrace.join("\n")
  end

  start_date = Date.current - 470.days
  expected_end = start_date + 36.months
  actual_end = Date.current - (30 + i * 10).days

  result = create_vehicle_and_contract(order, {
    license_plate: "IN#{3000 + i}DEF",
    vin: "VININACTIVE#{30 + i}ABCD",
    delivery_date: start_date,
    initial_km: 5,
    current_km: 40000 + (i * 3000),
    vehicle_status: "inactive",
    contract_status: "finalized",
    start_date: start_date,
    expected_end_date: expected_end,
    supplier_contract_number: "SC-FIN-#{3000 + i}"
  })

  begin
    result[:vehicle].deliver!
    result[:vehicle].initiate_return!
    result[:vehicle].complete_return!
    result[:contract].activate!
    result[:contract].initiate_closure!
    result[:contract].finalize!

    result[:contract].update!(
      termination_type: i < 2 ? "expiration" : "early",
      end_action: i == 2 ? "purchase_vehicle" : "return_vehicle",
      termination_request_date: actual_end - 20.days,
      closing_date: actual_end,
      actual_end_date: actual_end,
      closing_notes: i == 2 ? "Vehículo comprado por el cliente" : "Devolución completada sin incidencias"
    )
  rescue => e
    puts "    ❌ ERROR transitioning inactive details for order #{order.order_number}: #{e.message}"
    puts e.backtrace.join("\n")
  end

  orders << order
end

puts "    ✅ Created #{Renting::Order.count} orders"
puts "    ✅ Created #{Renting::Vehicle.count} vehicles"
puts "    ✅ Created #{Renting::Contract.count} contracts"

# ============================================================================
# SECTION 5: VEHICLE DELIVERIES
# ============================================================================
puts "\n🚚 SECTION 5: Creating Vehicle Deliveries..."

deliveries = []

# Get vehicles for delivery scenarios
vehicles_pending = Renting::Vehicle.where(status: "pending_delivery").to_a
vehicles_active = Renting::Vehicle.where(status: "active").limit(4).to_a

# Pending scheduling deliveries (3)
vehicles_pending.take(3).each_with_index do |vehicle, i|
  deliveries << Renting::VehicleDelivery.create!(
    vehicle: vehicle,
    order: vehicle.order,
    status: "pending_scheduling",
    scheduled_by: nil,
    confirmed_by: nil
  )
end

# Scheduled deliveries (3)
vehicles_active.take(3).each_with_index do |vehicle, i|
  delivery = Renting::VehicleDelivery.create!(
    vehicle: vehicle,
    order: vehicle.order,
    status: "pending_scheduling",
    scheduled_by: nil,
    confirmed_by: nil
  )

  delivery.schedule!
  delivery.update!(
    scheduled_date: Date.current + (5 + i).days,
    scheduled_time: Time.parse("10:00"),
    scheduled_location: [ "Madrid - Oficina Central", "Barcelona - Delegación", "Valencia - Punto de Entrega" ][i],
    scheduling_notes: "Entrega programada",
    scheduled_by: users[:manager1],
    scheduled_at: Time.current - i.days,
    reschedule_count: i > 0 ? 1 : 0
  )

  deliveries << delivery
end

# Confirmed deliveries (4)
vehicles_active.drop(3).take(4).each_with_index do |vehicle, i|
  delivery = Renting::VehicleDelivery.create!(
    vehicle: vehicle,
    order: vehicle.order,
    status: "pending_scheduling"
  )

  delivery.schedule!
  delivery.update!(
    scheduled_date: vehicle.delivery_date,
    scheduled_time: Time.parse("#{9 + i}:00"),
    scheduled_location: [ "Madrid - Oficina Central", "Barcelona - Delegación", "Sevilla - Punto de Entrega", "Valencia - Oficina" ][i],
    scheduling_notes: "Entrega confirmada",
    scheduled_by: users[:manager2],
    scheduled_at: vehicle.delivery_date - 5.days
  )

  delivery.confirm!
  delivery.update!(
    confirmed_by: users[:user1],
    confirmed_at: vehicle.delivery_date + 2.hours
  )

  deliveries << delivery
end

# Cancelled delivery (1)
if vehicles_pending.length > 3
  delivery = Renting::VehicleDelivery.create!(
    vehicle: vehicles_pending[3],
    order: vehicles_pending[3].order,
    status: "pending_scheduling"
  )

  delivery.schedule!
  delivery.update!(
    scheduled_date: Date.current + 3.days,
    scheduled_time: Time.parse("14:00"),
    scheduled_location: "Madrid - Oficina Central",
    scheduling_notes: "Entrega cancelada por el cliente",
    scheduled_by: users[:manager1],
    scheduled_at: Time.current - 2.days
  )

  delivery.cancel!
  deliveries << delivery
end

puts "    ✅ Created #{Renting::VehicleDelivery.count} vehicle deliveries"

# ============================================================================
# SECTION 6: VEHICLE RETURNS
# ============================================================================
puts "\n🔙 SECTION 6: Creating Vehicle Returns..."

returns = []

# Get vehicles for return scenarios
vehicles_pending_return = Renting::Vehicle.where(status: "pending_return").to_a
vehicles_inactive = Renting::Vehicle.where(status: "inactive").to_a

# Pending scheduling returns (2)
vehicles_pending_return.take(2).each_with_index do |vehicle, i|
  returns << Renting::VehicleReturn.create!(
    vehicle: vehicle,
    contract: vehicle.contract,
    status: "pending_scheduling"
  )
end

# Scheduled returns (2 from pending_return if available)
if vehicles_pending_return.length > 2
  vehicles_pending_return.drop(2).take(2).each_with_index do |vehicle, i|
    vehicle_return = Renting::VehicleReturn.create!(
      vehicle: vehicle,
      contract: vehicle.contract,
      status: "pending_scheduling"
    )

    vehicle_return.schedule!
    vehicle_return.update!(
      scheduled_date: Date.current + (10 + i * 5).days,
      scheduled_time: Time.parse("11:00"),
      scheduled_location: [ "Madrid - Centro de Devoluciones", "Barcelona - Punto de Recogida" ][i],
      scheduling_notes: "Devolución programada al finalizar contrato",
      scheduled_by: users[:manager1],
      scheduled_at: Time.current - i.days,
      reschedule_count: 0
    )

    returns << vehicle_return
  end
end

# Confirmed returns (3 from inactive vehicles)
vehicles_inactive.take(3).each_with_index do |vehicle, i|
  vehicle_return = Renting::VehicleReturn.create!(
    vehicle: vehicle,
    contract: vehicle.contract,
    status: "pending_scheduling"
  )

  vehicle_return.schedule!
  return_date = vehicle.contract.actual_end_date || (Date.current - 30.days)

  vehicle_return.update!(
    scheduled_date: return_date - 5.days,
    scheduled_time: Time.parse("#{10 + i}:00"),
    scheduled_location: [ "Madrid - Centro de Devoluciones", "Barcelona - Punto de Recogida", "Valencia - Centro" ][i],
    scheduling_notes: "Devolución programada",
    scheduled_by: users[:manager2],
    scheduled_at: return_date - 10.days
  )

  vehicle_return.confirm!
  vehicle_return.update!(
    actual_return_date: return_date,
    final_km: vehicle.current_km,
    return_notes: [ "Vehículo en buen estado", "Desgaste normal", "Requiere limpieza profunda" ][i],
    confirmed_by: users[:user1],
    confirmed_at: return_date + 1.hour
  )

  returns << vehicle_return
end

# Cancelled return (1)
if vehicles_inactive.length > 3
  vehicle_return = Renting::VehicleReturn.create!(
    vehicle: vehicles_inactive[3],
    contract: vehicles_inactive[3].contract,
    status: "pending_scheduling"
  )

  vehicle_return.schedule!
  vehicle_return.update!(
    scheduled_date: Date.current - 5.days,
    scheduled_time: Time.parse("15:00"),
    scheduled_location: "Madrid - Centro de Devoluciones",
    scheduling_notes: "Cancelada - vehículo comprado por cliente",
    scheduled_by: users[:manager1],
    scheduled_at: Date.current - 10.days
  )

  vehicle_return.cancel!
  returns << vehicle_return
end

puts "    ✅ Created #{Renting::VehicleReturn.count} vehicle returns"

# ============================================================================
# FINAL SUMMARY
# ============================================================================
puts "\n" + "=" * 80
puts "🎉 SEEDING COMPLETED SUCCESSFULLY!"
puts "=" * 80
puts "\n📊 DATABASE SUMMARY:"
puts "  Master Data:"
puts "    - Companies: #{Company.count}"
puts "    - Suppliers: #{Supplier.count}"
puts "    - Users: #{User.count}"
puts "    - Cost Centers: #{CostCenter.count}"
puts "    - Departments: #{Department.count}"
puts "    - Divisions: #{Division.count}"
puts "\n  Renting Configuration:"
puts "    - Order Series: #{Renting::OrderSeries.count}"
puts "    - Vehicle Types: #{Renting::VehicleType.count}"
puts "    - Services: #{Renting::Service.count}"
puts "\n  Authorization:"
puts "    - Authorization Rules: #{AuthorizationRule.count}"
puts "    - Authorization Requests: #{AuthorizationRequest.count}"
puts "    - Authorization Approvals: #{AuthorizationApproval.count}"
puts "\n  Orders & Vehicles:"
puts "    - Orders: #{Renting::Order.count}"
puts "      • created: #{Renting::Order.where(status: 'created').count}"
puts "      • pending_authorization: #{Renting::Order.where(status: 'pending_authorization').count}"
puts "      • authorized: #{Renting::Order.where(status: 'authorized').count}"
puts "      • rejected: #{Renting::Order.where(status: 'rejected').count}"
puts "      • pending_supplier_confirmation: #{Renting::Order.where(status: 'pending_supplier_confirmation').count}"
puts "      • confirmed: #{Renting::Order.where(status: 'confirmed').count}"
puts "      • finished: #{Renting::Order.where(status: 'finished').count}"
puts "      • cancelled: #{Renting::Order.where(status: 'cancelled').count}"
puts "\n    - Vehicles: #{Renting::Vehicle.count}"
puts "      • pending_delivery: #{Renting::Vehicle.where(status: 'pending_delivery').count}"
puts "      • active: #{Renting::Vehicle.where(status: 'active').count}"
puts "      • immobilized: #{Renting::Vehicle.where(status: 'immobilized').count}"
puts "      • pending_return: #{Renting::Vehicle.where(status: 'pending_return').count}"
puts "      • inactive: #{Renting::Vehicle.where(status: 'inactive').count}"
puts "\n    - Contracts: #{Renting::Contract.count}"
puts "      • pending_signature: #{Renting::Contract.where(status: 'pending_signature').count}"
puts "      • active: #{Renting::Contract.where(status: 'active').count}"
puts "      • pending_closure: #{Renting::Contract.where(status: 'pending_closure').count}"
puts "      • finalized: #{Renting::Contract.where(status: 'finalized').count}"
puts "\n  Logistics:"
puts "    - Vehicle Deliveries: #{Renting::VehicleDelivery.count}"
puts "      • pending_scheduling: #{Renting::VehicleDelivery.where(status: 'pending_scheduling').count}"
puts "      • scheduled: #{Renting::VehicleDelivery.where(status: 'scheduled').count}"
puts "      • confirmed: #{Renting::VehicleDelivery.where(status: 'confirmed').count}"
puts "      • cancelled: #{Renting::VehicleDelivery.where(status: 'cancelled').count}"
puts "\n    - Vehicle Returns: #{Renting::VehicleReturn.count}"
puts "      • pending_scheduling: #{Renting::VehicleReturn.where(status: 'pending_scheduling').count}"
puts "      • scheduled: #{Renting::VehicleReturn.where(status: 'scheduled').count}"
puts "      • confirmed: #{Renting::VehicleReturn.where(status: 'confirmed').count}"
puts "      • cancelled: #{Renting::VehicleReturn.where(status: 'cancelled').count}"
puts "\n" + "=" * 80
puts "✨ Ready for testing! All scenarios covered."
puts "=" * 80
