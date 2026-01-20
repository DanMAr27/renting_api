class CreateRentingOrderDeliveryHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :renting_order_delivery_histories do |t|
      t.bigint :order_id
      t.string :event_type
      t.date :scheduled_date
      t.bigint :registered_by_id
      t.text :notes

      t.timestamps
    end
  end
end
