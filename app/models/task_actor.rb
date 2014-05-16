class TaskActor < ActiveRecord::Base
  # one - has many (task actor) relationship
  belongs_to :task
  belongs_to :user

  # task must be an actual task
  validates :task, existence: { :allow_nil => false }
  # member (user) must be an actual user
  validates :user, existence: { :allow_nil => false }
  # order must be present and unique
  # it is set internally so no check necessary, just need to be careful
  validates :order, presence: true
  # member must be in the group
  validate :user_in_group?

  # validates whether the member is in the group
  def user_in_group?
    if !task.group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group of the task")
    end
  end
end
