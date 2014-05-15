class TaskGenerator < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  has_many :task_generator_actors, :dependent => :destroy
  has_many :users, :through => :task_generator_actors
end
