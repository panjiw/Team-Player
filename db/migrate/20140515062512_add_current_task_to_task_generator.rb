class AddCurrentTaskToTaskGenerator < ActiveRecord::Migration
  def change
    remove_column :task_generators, :current_actor_order
    add_column :task_generators, :current_task_id, :integer
  end
end
