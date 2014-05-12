class Bill < ActiveRecord::
  belongs_to :group
  belongs_to :user

  has_many :bill_actors
  has_many :users, :through => :bill_actors

  validates :title, presence: true, length: { maximum: 255 }
  validates :group, existence: { :allow_nil => false }
  validates :user, existence: { :allow_nil => false }
  VALID_DUE_REGEX = /^\d+(\.\d{2})?$/
  validates :total_due, format: { with: VALID_DUE_REGEX }, numericality: { greater_than: 0 }
  validate :creator_in_group?

  # checking total, need bill to check bill_actors and vice versa, what to do?

  def creator_in_group?
    if !group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group")
    end
  end
end
