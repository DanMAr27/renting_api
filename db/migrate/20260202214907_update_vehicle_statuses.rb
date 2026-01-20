# frozen_string_literal: true

class UpdateVehicleStatuses < ActiveRecord::Migration[8.0]
  def up
    # Renombrar in_maintenance -> immobilized
    execute <<-SQL
      UPDATE renting_vehicles#{' '}
      SET status = 'immobilized'#{' '}
      WHERE status = 'in_maintenance';
    SQL

    # Renombrar returned -> inactive
    execute <<-SQL
      UPDATE renting_vehicles#{' '}
      SET status = 'inactive'#{' '}
      WHERE status = 'returned';
    SQL

    # Mapear in_transit a pending_delivery (estado más apropiado)
    execute <<-SQL
      UPDATE renting_vehicles#{' '}
      SET status = 'pending_delivery'#{' '}
      WHERE status = 'in_transit';
    SQL
  end

  def down
    # Revertir cambios
    execute <<-SQL
      UPDATE renting_vehicles#{' '}
      SET status = 'in_maintenance'#{' '}
      WHERE status = 'immobilized';
    SQL

    execute <<-SQL
      UPDATE renting_vehicles#{' '}
      SET status = 'returned'#{' '}
      WHERE status = 'inactive';
    SQL
  end
end
