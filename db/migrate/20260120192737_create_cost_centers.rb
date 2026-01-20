class CreateCostCenters < ActiveRecord::Migration[8.0]
  def change
    create_table :cost_centers do |t|
      t.string :code
      t.string :name
      t.text :description
      t.boolean :active

      t.timestamps
    end
  end
end
