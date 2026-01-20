class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :tax_id
      t.text :address
      t.boolean :active

      t.timestamps
    end
  end
end
