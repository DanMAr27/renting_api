class CreateAuthorizationApprovals < ActiveRecord::Migration[8.0]
  def change
    create_table :authorization_approvals do |t|
      t.bigint :authorization_request_id
      t.bigint :approver_id
      t.integer :approval_level
      t.string :action
      t.text :notes
      t.datetime :approved_at

      t.timestamps
    end
  end
end
