class Group < ActiveRecord::Base

  # group - user, many-many relation
  has_many :memberships, :class_name => "Membership"
  has_many :acceptmemberships, :class_name => "Acceptmembership"

  has_many :users, :through => :memberships
  has_many :pending_users, :through => :acceptmemberships, :source => :user

  validates :name, presence: true, length: {maximum: 64}
  validates :creator, presence: true

  # task - group, many-many relation
  has_many :tasks, :dependent => :destroy

  # bill - group, many-many relation
  has_many :bills, :dependent => :destroy

  # task generator - group, many-many relation
  has_many :task_generators, :dependent => :destroy
end
