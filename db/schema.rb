# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_02_02_225702) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "authorization_approvals", force: :cascade do |t|
    t.bigint "authorization_request_id"
    t.bigint "approver_id"
    t.integer "approval_level"
    t.string "action"
    t.text "notes"
    t.datetime "approved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authorization_requests", force: :cascade do |t|
    t.string "authorizable_type"
    t.bigint "authorizable_id"
    t.bigint "requested_by_id"
    t.decimal "amount"
    t.string "status"
    t.integer "current_level"
    t.integer "max_level"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authorization_rules", force: :cascade do |t|
    t.string "authorizable_type"
    t.string "name"
    t.string "condition_field"
    t.string "condition_operator"
    t.decimal "condition_value"
    t.string "required_role"
    t.integer "approval_level"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "tax_id"
    t.text "address"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cost_centers", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.text "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.text "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "divisions", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.text "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_series", force: :cascade do |t|
    t.string "code"
    t.string "prefix"
    t.integer "current_counter"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "renting_contracts", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "vehicle_id"
    t.bigint "supplier_id"
    t.bigint "company_id"
    t.string "supplier_contract_number"
    t.integer "duration_months"
    t.integer "annual_km"
    t.decimal "monthly_fee"
    t.date "start_date"
    t.date "expected_end_date"
    t.date "actual_end_date"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "termination_type"
    t.string "end_action"
    t.date "termination_request_date"
    t.date "closing_date"
    t.text "closing_notes"
  end

  create_table "renting_order_assignments", force: :cascade do |t|
    t.bigint "order_id"
    t.string "usage_type"
    t.bigint "driver_id"
    t.bigint "cost_center_id"
    t.bigint "department_id"
    t.bigint "division_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "renting_order_contract_conditions", force: :cascade do |t|
    t.bigint "order_id"
    t.integer "duration_months"
    t.integer "annual_km"
    t.decimal "monthly_fee"
    t.decimal "initial_payment"
    t.decimal "deposit"
    t.date "contract_start_date"
    t.date "contract_end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "renting_order_delivery_histories", force: :cascade do |t|
    t.bigint "order_id"
    t.string "event_type"
    t.date "scheduled_date"
    t.bigint "registered_by_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "renting_order_services", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "service_id"
    t.decimal "monthly_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "renting_order_status_histories", force: :cascade do |t|
    t.bigint "order_id"
    t.string "from_status"
    t.string "to_status"
    t.bigint "changed_by_id"
    t.datetime "changed_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "renting_order_vehicle_specs", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "vehicle_type_id"
    t.string "fuel_type"
    t.string "environmental_label"
    t.integer "min_seats"
    t.string "transmission"
    t.string "preferred_color"
    t.text "additional_equipment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "renting_orders", force: :cascade do |t|
    t.string "order_number"
    t.bigint "company_id"
    t.bigint "supplier_id"
    t.bigint "order_series_id"
    t.bigint "created_by_id"
    t.string "status"
    t.date "order_date"
    t.date "expected_delivery_date"
    t.date "actual_delivery_date"
    t.boolean "is_renewal"
    t.bigint "old_vehicle_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "renting_vehicle_deliveries", force: :cascade do |t|
    t.bigint "vehicle_id", null: false
    t.bigint "order_id", null: false
    t.string "status", default: "pending_scheduling", null: false
    t.date "scheduled_date"
    t.time "scheduled_time"
    t.string "scheduled_location"
    t.text "scheduling_notes"
    t.integer "reschedule_count", default: 0
    t.datetime "scheduled_at"
    t.bigint "scheduled_by_id"
    t.datetime "confirmed_at"
    t.bigint "confirmed_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmed_by_id"], name: "index_renting_vehicle_deliveries_on_confirmed_by_id"
    t.index ["order_id"], name: "index_renting_vehicle_deliveries_on_order_id"
    t.index ["scheduled_by_id"], name: "index_renting_vehicle_deliveries_on_scheduled_by_id"
    t.index ["status"], name: "index_renting_vehicle_deliveries_on_status"
    t.index ["vehicle_id"], name: "index_renting_vehicle_deliveries_on_vehicle_id"
  end

  create_table "renting_vehicle_returns", force: :cascade do |t|
    t.bigint "vehicle_id", null: false
    t.bigint "contract_id", null: false
    t.string "status", default: "pending_scheduling", null: false
    t.date "scheduled_date"
    t.time "scheduled_time"
    t.string "scheduled_location"
    t.text "scheduling_notes"
    t.integer "reschedule_count", default: 0
    t.bigint "scheduled_by_id"
    t.datetime "scheduled_at"
    t.date "actual_return_date"
    t.integer "final_km"
    t.text "return_notes"
    t.bigint "confirmed_by_id"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmed_by_id"], name: "index_renting_vehicle_returns_on_confirmed_by_id"
    t.index ["contract_id"], name: "index_renting_vehicle_returns_on_contract_id"
    t.index ["scheduled_by_id"], name: "index_renting_vehicle_returns_on_scheduled_by_id"
    t.index ["status"], name: "index_renting_vehicle_returns_on_status"
    t.index ["vehicle_id"], name: "index_renting_vehicle_returns_on_vehicle_id"
  end

  create_table "renting_vehicles", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "vehicle_type_id"
    t.string "license_plate"
    t.string "vin"
    t.string "fuel_type"
    t.string "transmission"
    t.string "color"
    t.date "delivery_date"
    t.integer "initial_km"
    t.integer "current_km"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.text "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "tax_id"
    t.string "contact_email"
    t.string "contact_phone"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password"
    t.string "name"
    t.string "role"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "vehicle_types", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.text "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "renting_vehicle_deliveries", "renting_orders", column: "order_id"
  add_foreign_key "renting_vehicle_deliveries", "renting_vehicles", column: "vehicle_id"
  add_foreign_key "renting_vehicle_deliveries", "users", column: "confirmed_by_id"
  add_foreign_key "renting_vehicle_deliveries", "users", column: "scheduled_by_id"
  add_foreign_key "renting_vehicle_returns", "renting_contracts", column: "contract_id"
  add_foreign_key "renting_vehicle_returns", "renting_vehicles", column: "vehicle_id"
  add_foreign_key "renting_vehicle_returns", "users", column: "confirmed_by_id"
  add_foreign_key "renting_vehicle_returns", "users", column: "scheduled_by_id"
end
