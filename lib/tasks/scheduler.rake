desc "This task is called by the Heroku scheduler add-on"
require "#{Rails.root}/app/helpers/task_generators_helper"
include TaskGeneratorsHelper

# Creates a new task for all task generators where their
# latest task was due yesterday
task :generate_tasks => :environment do
  yesterday = Date.today - 1
  TaskGenerator.where("finished = ?", false).find_each do |g|
    current_task = Task.find(g[:current_task_id])
    if current_task
      if current_task[:due_date] == yesterday
        new_task g
      end
    end
  end
end