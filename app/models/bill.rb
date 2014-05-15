class Bill < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  has_many :bill_actors, :dependent => :destroy
  has_many :users, :through => :bill_actors

  validates :title, presence: true, length: { maximum: 255 }
  validates :group, existence: { :allow_nil => false }
  validates :user, existence: { :allow_nil => false }
  validates :total_due, numericality: { greater_than: 0 }
  validate :creator_in_group?

  # checking total, need bill to check bill_actors and vice versa, what to do?
  # done dynamically

  # no need to check whether a user is in twice as what expected is a map
  # can't have duplicate keys (id) in a map

  # Unlike task, finished is different for each member

  def creator_in_group?
    return unless errors.blank?
    if !group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group")
    end
  end
end
