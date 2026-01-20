class CreateAuthorizationRules < ActiveRecord::Migration[8.0]
  def change
    create_table :authorization_rules do |t|
      t.string :authorizable_type
      t.string :name
      t.string :condition_field
      t.string :condition_operator
      t.decimal :condition_value
      t.string :required_role
      t.integer :approval_level
      t.boolean :active

      t.timestamps
    end
  end
end
