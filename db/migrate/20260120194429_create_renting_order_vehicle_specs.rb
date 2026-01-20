class CreateRentingOrderVehicleSpecs < ActiveRecord::Migration[8.0]
  def change
    create_table :renting_order_vehicle_specs do |t|
      t.bigint :order_id
      t.bigint :vehicle_type_id
      t.string :fuel_type
      t.string :environmental_label
      t.integer :min_seats
      t.string :transmission
      t.string :preferred_color
      t.text :additional_equipment

      t.timestamps
    end
  end
end
