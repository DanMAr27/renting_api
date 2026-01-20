# frozen_string_literal: true

class UpdateContractStatuses < ActiveRecord::Migration[8.0]
  def up
    # Renombrar pending_formalization -> pending_signature
    execute <<-SQL
      UPDATE renting_contracts#{' '}
      SET status = 'pending_signature'#{' '}
      WHERE status = 'pending_formalization';
    SQL

    # Renombrar completed -> finalized
    execute <<-SQL
      UPDATE renting_contracts#{' '}
      SET status = 'finalized'#{' '}
      WHERE status = 'completed';
    SQL

    # Mapear suspended y cancelled a finalized
    execute <<-SQL
      UPDATE renting_contracts#{' '}
      SET status = 'finalized'#{' '}
      WHERE status IN ('suspended', 'cancelled');
    SQL
  end

  def down
    # Revertir cambios
    execute <<-SQL
      UPDATE renting_contracts#{' '}
      SET status = 'pending_formalization'#{' '}
      WHERE status = 'pending_signature';
    SQL

    execute <<-SQL
      UPDATE renting_contracts#{' '}
      SET status = 'completed'#{' '}
      WHERE status = 'finalized';
    SQL
  end
end
