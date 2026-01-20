class CreateDepartments < ActiveRecord::Migration[8.0]
  def change
    create_table :departments do |t|
      t.string :code
      t.string :name
      t.text :description
      t.boolean :active

      t.timestamps
    end
  end
end
