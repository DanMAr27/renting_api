class CreateRentingOrderStatusHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :renting_order_status_histories do |t|
      t.bigint :order_id
      t.string :from_status
      t.string :to_status
      t.bigint :changed_by_id
      t.datetime :changed_at
      t.text :notes

      t.timestamps
    end
  end
end
