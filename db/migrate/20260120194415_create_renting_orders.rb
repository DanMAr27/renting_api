class CreateRentingOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :renting_orders do |t|
      t.string :order_number
      t.bigint :company_id
      t.bigint :supplier_id
      t.bigint :order_series_id
      t.bigint :created_by_id
      t.string :status
      t.date :order_date
      t.date :expected_delivery_date
      t.date :actual_delivery_date
      t.boolean :is_renewal
      t.bigint :old_vehicle_id
      t.text :notes

      t.timestamps
    end
  end
end
