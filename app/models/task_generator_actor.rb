class TaskGeneratorActor < ActiveRecord::Base
  belongs_to :task_generator
  belongs_to :user

  validates :task_generator, existence: { :allow_nil => false }
  validates :user, existence: { :allow_nil => false }
  validates :order, presence: true #order set internally so no check (ex: for duplicates)
                                   # necessary, just be careful

  validate :user_in_group?

  def user_in_group?
    if !task_generator.group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group of the task generator")
    end
  end
end
