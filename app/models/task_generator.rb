class TaskGenerator < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  has_many :task_generator_actors, :dependent => :destroy
  has_many :users, :through => :task_generator_actors

  serialize :repeat_days

  validates :title, presence: true, length: { maximum: 255 }
  validates :finished, :inclusion => {:in => [true, false]} # indicates whether its dead
  validates :group, existence: { :allow_nil => false }
  validates :user, existence: { :allow_nil => false }
  validates :cycle, :inclusion => {:in => [true, false]}
  validate :creator_in_group?

  # current_task_id has no relation because it's going to keep changing
  # not checked because will be set internally, so have to be careful

  # no need to check whether a user is in twice as what expected is a map
  # can't have duplicate keys (id) in a map


  # cycle -> cycle current actor
  # repeat -> determines the next date (based on date) of the next task
  # cycle + no repeat -> must be a to-do, no due date
  # cycle + repeat -> a due date will be created based on the nearest day
  #                   on repeat that the generator is called
  # no cycle + repeat -> same as above but the user doesn't change
  # no cycle + no repeat -> you're not supposed to be here


  def creator_in_group?
    if !group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group")
    end
  end
end
