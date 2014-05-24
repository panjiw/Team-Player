class AddIdToActors < ActiveRecord::Migration
  def change
    add_column :bill_actors, :id, :primary_key
    add_column :task_actors, :id, :primary_key
    add_column :task_generator_actors, :id, :primary_key
  end
end
