class BillActor < ActiveRecord::Base
  belongs_to :bill
  belongs_to :user

  validates :bill, existence: { :allow_nil => false }
  validates :user, existence: { :allow_nil => false }
  VALID_DUE_REGEX = /^\d+(\.\d{2})?$/
  validates :due, format: { with: VALID_DUE_REGEX }, numericality: { greater_than: 0 }
  validates :paid, :inclusion => {:in => [true, false]}

  validate :user_in_group?

  def user_in_group?
    if !task.group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group of the task")
    end
  end
end
