class CreateSuppliers < ActiveRecord::Migration[8.0]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :tax_id
      t.string :contact_email
      t.string :contact_phone
      t.boolean :active

      t.timestamps
    end
  end
end
