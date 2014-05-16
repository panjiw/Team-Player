class BillActor < ActiveRecord::Base
  # one - has many (bill actor) relationship
  belongs_to :bill
  belongs_to :user

  # bill must be an actual bill
  validates :bill, existence: { :allow_nil => false }
  # member (user) must be an actual user
  validates :user, existence: { :allow_nil => false }
  # due is in cents and must be greater than 0
  validates :due, numericality: { greater_than: 0 }
  # paid must be present boolean
  validates :paid, :inclusion => {:in => [true, false]}
  # member must be in the group
  validate :user_in_group?

  # validates whether the creator is in the group
  def user_in_group?
    return unless errors.blank?
    if !bill.group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group of the task")
    end
  end
end
