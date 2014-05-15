class TaskGenerator < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  has_many :task_generator_actors, :dependent => :destroy
  has_many :users, :through => :task_generator_actors

  validates :title, presence: true, length: { maximum: 255 }
  validates :finished, :inclusion => {:in => [true, false]} # indicates whether its dead
  validates :group, existence: { :allow_nil => false }
  validates :user, existence: { :allow_nil => false }
  validates :cycle, :inclusion => {:in => [true, false]}
  validates :current_actor_order, numericality: { greater_than_or_equal_to: 0 }
  validate :creator_in_group?

  # no need to check whether a user is in twice as what expected is a map
  # can't have duplicate keys (id) in a map

  def creator_in_group?
    if !group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group")
    end
  end
end
