class Group < ActiveRecord::Base

  # group - user, many-many relation
  has_many :memberships
  has_many :users, :through => :memberships
  validates :title, presence: true, length: {maximum: 64}
  validates :creator, presence: true
end
