class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships, :id => false do |t|
      t.integer :group_id
      t.integer :user_id

      t.timestamps
    end
    add_index :memberships, :user_id
    add_index :memberships, :group_id
    add_index :memberships, [:user_id, :group_id], unique: true
  end
end
