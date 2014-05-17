class AddDueDateToTaskGenerator < ActiveRecord::Migration
  def change
    add_column :task_generators, :due_date, :date
  end
end
