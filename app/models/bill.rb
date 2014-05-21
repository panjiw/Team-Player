#
# TeamPlayer -- 2014
#
# Models the Bill
#

class Bill < ActiveRecord::Base
  # one - has many (bill) relationship
  belongs_to :group
  belongs_to :user

  # one (bill) - has many relationships
  has_many :bill_actors, :dependent => :delete_all
  has_many :users, :through => :bill_actors

  # title must be there and at most 255 char
  validates :title, presence: true, length: { maximum: 255 }
  # group of the creator must be an actual group
  validates :group, existence: { :allow_nil => false }
  # creator (user) must be an actual user
  validates :user, existence: { :allow_nil => false }
  # total due is in cents and must be greater than 0
  validates :total_due, numericality: { greater_than: 0 }
  # creator must be in the group
  validate :creator_in_group?

  # total due correctly divided is checked dynamically
  # in the controller

  # users that are members that have dues are not checked
  # whether they're assigned twice as they are listed
  # as keys in a map

  # finished is per member basis

  # validates whether the creator is in the group
  def creator_in_group?
    return unless errors.blank?
    if !group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group")
    end
  end
end
