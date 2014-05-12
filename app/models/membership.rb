class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates :user_id, presence: true
  validates :group_id, presence: true
end
