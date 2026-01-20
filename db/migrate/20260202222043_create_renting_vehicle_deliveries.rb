# frozen_string_literal: true

class CreateRentingVehicleDeliveries < ActiveRecord::Migration[8.0]
  def change
    create_table :renting_vehicle_deliveries do |t|
      # Relaciones
      t.references :vehicle, null: false, foreign_key: { to_table: :renting_vehicles }, index: true
      t.references :order, null: false, foreign_key: { to_table: :renting_orders }

      # Estado
      t.string :status, null: false, default: "pending_scheduling"

      # Programación (opcional)
      t.date :scheduled_date
      t.time :scheduled_time
      t.string :scheduled_location
      t.text :scheduling_notes
      t.integer :reschedule_count, default: 0
      t.datetime :scheduled_at
      t.references :scheduled_by, foreign_key: { to_table: :users }

      # Confirmación (Solo metadatos, los datos reales van a Vehicle/Contract)
      t.datetime :confirmed_at
      t.references :confirmed_by, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :renting_vehicle_deliveries, :status
  end
end
