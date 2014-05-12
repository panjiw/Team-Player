class CreateBillActors < ActiveRecord::Migration
  def change
    create_table :bill_actors do |t|
      t.integer :bill_id
      t.integer :user_id
      t.decimal :due, :precision => 8, :scale => 2
      t.date :paid_date
      t.boolean :paid

      t.timestamps
    end
  end
end
