class TaskGenerator < ActiveRecord::Base
  # one - has many (task generator) relationship
  belongs_to :group
  belongs_to :user

  # one (task generator) - has many relationships
  has_many :task_generator_actors, :dependent => :destroy
  has_many :users, :through => :task_generator_actors

  # save the repeat pattern hash
  serialize :repeat_days

  # title must be there and at most 255 char
  validates :title, presence: true, length: { maximum: 255 }
  # finished must be present boolean
  # indicates whether its dead
  validates :finished, :inclusion => {:in => [true, false]}
  # group of the creator must be an actual group
  validates :group, existence: { :allow_nil => false }
  # creator (user) must be an actual user
  validates :user, existence: { :allow_nil => false }
  # finished must be present boolean
  validates :cycle, :inclusion => {:in => [true, false]}
  # creator must be in the group
  validate :creator_in_group?

  # current_task_id has no relation because it's going
  # to keep changing not checked because will be set internally,
  # so have to be careful

  # users that are members are not checked whether they're
  # assigned twice as they are listed as keys in a map

  # behavior
  # cycle -> cycle current actor
  # repeat -> determines the next date (based on date) of the next task
  # cycle + no repeat -> a to-do, must have no due date
  # cycle + repeat -> a due date will be based on the nearest day
  #                   on repeat that the generator is called
  # no cycle + repeat -> same as above but the user doesn't change
  # no cycle + no repeat -> you're not supposed to be here

  # validates whether the creator is in the group
  def creator_in_group?
    if !group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group")
    end
  end
end
