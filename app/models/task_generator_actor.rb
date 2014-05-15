class TaskGeneratorActor < ActiveRecord::Base
  belongs_to :task_generator
  belongs_to :user

end
