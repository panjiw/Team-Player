class RemoveDueDateFromTaskGenerator < ActiveRecord::Migration
  def change
    remove_column :task_generators, :due_date
  end
end
