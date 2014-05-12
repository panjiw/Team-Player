class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.integer :group_id
      t.integer :user_id #creator
      t.string :title
      t.string :description
      t.date :due_date
      t.decimal :total_due, :precision => 8, :scale => 2

      t.timestamps
    end
  end
end
