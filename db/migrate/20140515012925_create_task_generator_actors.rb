class CreateTaskGeneratorActors < ActiveRecord::Migration
  def change
    create_table :task_generator_actors, :id => false do |t|
      t.integer :task_generator_id
      t.integer :user_id
      t.integer :order

      t.timestamps
    end
  end
end
