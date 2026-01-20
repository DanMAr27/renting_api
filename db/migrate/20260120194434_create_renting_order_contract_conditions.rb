class CreateRentingOrderContractConditions < ActiveRecord::Migration[8.0]
  def change
    create_table :renting_order_contract_conditions do |t|
      t.bigint :order_id
      t.integer :duration_months
      t.integer :annual_km
      t.decimal :monthly_fee
      t.decimal :initial_payment
      t.decimal :deposit
      t.date :contract_start_date
      t.date :contract_end_date

      t.timestamps
    end
  end
end
