class Task < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  # So users.first is the user doing the task
  # Task has access to all member that will do a cycling or repeating task (can't remember why)
  # Every new task created by a task creator just cycles the order
  has_many :task_actors, :dependent => :destroy
  has_many :users, :through => :task_actors

  validates :title, presence: true, length: { maximum: 255 }
  validates :finished, :inclusion => {:in => [true, false]}
  validates :group, existence: { :allow_nil => false }
  validates :user, existence: { :allow_nil => false }
  validate :creator_in_group?

  def creator_in_group?
    if !group.users.include?(user)
      errors.add(:user, user.username + " isn't in the group")
    end
  end
end
