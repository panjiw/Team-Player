class TaskActor < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  validates :task, existence: { :allow_nil => false }
  validates :user, existence: { :allow_nil => false }
  validates :order, presence: true #order set internally so no check necessary, just be careful

  validate :user_in_group?

  def user_in_group?
    if !task.group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group of the task")
    end
  end
end
