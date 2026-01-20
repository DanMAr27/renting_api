class CreateRentingOrderAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :renting_order_assignments do |t|
      t.bigint :order_id
      t.string :usage_type
      t.bigint :driver_id
      t.bigint :cost_center_id
      t.bigint :department_id
      t.bigint :division_id

      t.timestamps
    end
  end
end
