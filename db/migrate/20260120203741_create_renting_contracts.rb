class CreateRentingContracts < ActiveRecord::Migration[8.0]
  def change
    create_table :renting_contracts do |t|
      t.bigint :order_id
      t.bigint :vehicle_id
      t.bigint :supplier_id
      t.bigint :company_id
      t.string :supplier_contract_number
      t.integer :duration_months
      t.integer :annual_km
      t.decimal :monthly_fee
      t.date :start_date
      t.date :expected_end_date
      t.date :actual_end_date
      t.string :status

      t.timestamps
    end
  end
end
