class TaskGeneratorActor < ActiveRecord::Base
  # one - has many (task generator actor) relationship
  belongs_to :task_generator
  belongs_to :user

  # task generator must be an actual task generator
  validates :task_generator, existence: { :allow_nil => false }
  # member (user) must be an actual user
  validates :user, existence: { :allow_nil => false }
  # order must be present and unique
  # it is set internally so no check necessary, just need to be careful
  validates :order, presence: true
  # member must be in the group
  validate :user_in_group?

  # validates whether the member is in the group
  def user_in_group?
    if !task_generator.group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group of the task generator")
    end
  end
end
