class Group < ActiveRecord::Base

  # group - user, many-many relation
  has_many :memberships, :class_name => "Membership"
  has_many :users, :through => :memberships
  validates :name, presence: true, length: {maximum: 64}
  validates :creator, presence: true

end
