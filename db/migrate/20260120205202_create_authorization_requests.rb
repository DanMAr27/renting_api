class CreateAuthorizationRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :authorization_requests do |t|
      t.string :authorizable_type
      t.bigint :authorizable_id
      t.bigint :requested_by_id
      t.decimal :amount
      t.string :status
      t.integer :current_level
      t.integer :max_level
      t.datetime :completed_at

      t.timestamps
    end
  end
end
