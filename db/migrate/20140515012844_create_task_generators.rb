class CreateTaskGenerators < ActiveRecord::Migration
  def change
    create_table :task_generators do |t|
      t.integer :group_id
      t.integer :user_id #creator
      t.string :title
      t.string :description
      t.date :due_date
      t.date :finished_date
      t.boolean :finished
      t.text :repeat_days
      t.boolean :cycle
      t.integer :current_actor_order

      t.timestamps
    end
  end
end
