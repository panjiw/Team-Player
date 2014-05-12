class CreateTaskActors < ActiveRecord::Migration
  def change
    create_table :task_actors, :id => false do |t|
      t.integer :task_id
      t.integer :user_id
      t.integer :order

      t.timestamps
    end
  end
end
