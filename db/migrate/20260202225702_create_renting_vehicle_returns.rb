# frozen_string_literal: true

class CreateRentingVehicleReturns < ActiveRecord::Migration[8.0]
  def change
    create_table :renting_vehicle_returns do |t|
      # Relaciones
      t.references :vehicle, null: false, foreign_key: { to_table: :renting_vehicles }
      t.references :contract, null: false, foreign_key: { to_table: :renting_contracts } # Vincula al contrato que cierra

      # Estados AASM
      t.string :status, null: false, default: "pending_scheduling"

      # Agenda (Logística)
      t.date :scheduled_date
      t.time :scheduled_time
      t.string :scheduled_location
      t.text :scheduling_notes
      t.integer :reschedule_count, default: 0
      t.references :scheduled_by, foreign_key: { to_table: :users }
      t.datetime :scheduled_at

      # Confirmación (Recepción Física)
      t.date :actual_return_date
      t.integer :final_km
      t.text :return_notes
      t.references :confirmed_by, foreign_key: { to_table: :users }
      t.datetime :confirmed_at

      t.timestamps
    end

    add_index :renting_vehicle_returns, :status
  end
end
