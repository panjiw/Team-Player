desc "This task is called by the Heroku scheduler add-on"
task :generate_tasks => :environment do
  active_generators = TaskGenerator.find_by finished: false
  active_generators.each do |g|
    current_task = Task.find
  end
end