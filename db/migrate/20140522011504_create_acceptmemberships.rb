class CreateAcceptmemberships < ActiveRecord::Migration
  def change
    create_table :acceptmemberships, :id => false do |t|
      t.integer :group_id
      t.integer :user_id

      t.timestamps
    end
    add_index :acceptmemberships, :user_id
    add_index :acceptmemberships, :group_id
    add_index :acceptmemberships, [:user_id, :group_id], unique: true
  end
end
