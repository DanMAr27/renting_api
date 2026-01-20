class CreateOrderSeries < ActiveRecord::Migration[8.0]
  def change
    create_table :order_series do |t|
      t.string :code
      t.string :prefix
      t.integer :current_counter
      t.boolean :active

      t.timestamps
    end
  end
end
