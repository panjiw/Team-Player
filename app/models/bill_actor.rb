class BillActor < ActiveRecord::Base
  belongs_to :bill
  belongs_to :user

  validates :bill, existence: { :allow_nil => false }
  validates :user, existence: { :allow_nil => false }
  validates :due, numericality: { greater_than: 0 }
  validates :paid, :inclusion => {:in => [true, false]}

  validate :user_in_group?

  def user_in_group?
    return unless errors.blank?
    if !bill.group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group of the task")
    end
  end
end
