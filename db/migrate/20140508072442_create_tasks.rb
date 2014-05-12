class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :group_id
      t.integer :user_id
      t.string :title
      t.string :description
      t.date :due_date
      t.date :finished_date
      t.boolean :finished

      t.timestamps
    end
  end
end
