# frozen_string_literal: true

class AddTerminationToRentingContracts < ActiveRecord::Migration[8.0]
  def change
    add_column :renting_contracts, :termination_type, :string # expiration, early
    add_column :renting_contracts, :end_action, :string       # return_vehicle, purchase_vehicle
    add_column :renting_contracts, :termination_request_date, :date
    add_column :renting_contracts, :closing_date, :date
    add_column :renting_contracts, :closing_notes, :text
  end
end
