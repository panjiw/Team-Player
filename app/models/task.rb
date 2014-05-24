#
# TeamPlayer -- 2014
#
# Models the Task
#

class Task < ActiveRecord::Base
  # one - has many (task) relationship
  belongs_to :group
  belongs_to :user

  # one (task) - has many relationships
  # task_actor.find_by_order(0) is the user doing the task
  has_many :task_actors, :dependent => :destroy
  has_many :users, :through => :task_actors

  # title must be there and at most 255 char
  validates :title, presence: true, length: { maximum: 255 }
  # finished must be present boolean
  validates :finished, :inclusion => {:in => [true, false]}
  # group of the creator must be an actual group
  validates :group, existence: { :allow_nil => false }
  # creator (user) must be an actual user
  validates :user, existence: { :allow_nil => false }
  # creator must be in the group
  validate :creator_in_group?

  # users that are members are not checked whether they're
  # assigned twice as they are listed as keys in a map

  # finished is on a task basis

  # finished_date is set internally and there's really
  # no restriction except the ones from the Ruby Date class
  # so no validation needed

  # due_date isn't checked cause there could be no due date

  # Task has no knowledge of its creator as it could be
  # created by the user or by the generator

  # validates whether the creator is in the group
  def creator_in_group?
    return unless errors.blank?
    if !group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group")
    end
  end
end
