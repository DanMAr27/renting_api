class CreateRentingVehicles < ActiveRecord::Migration[8.0]
  def change
    create_table :renting_vehicles do |t|
      t.bigint :order_id
      t.bigint :vehicle_type_id
      t.string :license_plate
      t.string :vin
      t.string :fuel_type
      t.string :transmission
      t.string :color
      t.date :delivery_date
      t.integer :initial_km
      t.integer :current_km
      t.string :status

      t.timestamps
    end
  end
end
