class TaskActor < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  validates :task, existence: { :allow_nil => false }
  validates :user, existence: { :allow_nil => false }
  validates :order, presence: true #order set internally so no check necessary, just be careful
end
