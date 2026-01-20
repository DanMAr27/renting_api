class CreateRentingOrderServices < ActiveRecord::Migration[8.0]
  def change
    create_table :renting_order_services do |t|
      t.bigint :order_id
      t.bigint :service_id
      t.decimal :monthly_price

      t.timestamps
    end
  end
end
