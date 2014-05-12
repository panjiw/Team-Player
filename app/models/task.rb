class Task < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  has_many :task_actors
  has_many :users, :through => :task_actors

  validates :title, presence: true
  validates :finished, :inclusion => {:in => [true, false]}
  validates :group, existence: { :allow_nil => false }
  validates :user, existence: { :allow_nil => false }
end
