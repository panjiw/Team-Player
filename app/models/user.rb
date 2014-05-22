#
# TeamPlayer -- 2014
#
# Models a Team Player user
#
class User < ActiveRecord::Base

  # group - user, many-many relation
  has_many :memberships, :class_name => "Membership", dependent: :destroy
  has_many :acceptmemberships, :class_name => "Acceptmembership", dependent: :destroy

  has_many :groups, :through => :memberships
  has_many :pending_groups, :through => :acceptmemberships, :source => :group

  # task - user, many-many
  has_many :task_actors
  has_many :tasks, :through => :task_actors

  # bill - user, many-many
  has_many :bill_actors
  has_many :bills, :through => :bill_actors

  # tack generator - user, many-many
  has_many :task_generator_actors
  has_many :task_generators, :through => :task_generator_actors

  before_save {
    self.username = username.downcase
    self.email = email.downcase
  }

  # true if user is in group
  def self.member?(user, other_group)
    !(Membership.find_by(user: user, group: other_group).nil?)
  end

  # given group, user will join group
  def member!(other_group)
    memberships.create!(group: other_group)
  end

  #def unmember!(other_group)
  #  memberships.find_by(user_id: other_group.id).destroy
  #end


  # A user always have a session token
  before_create :create_remember_token

  # Rep Inv

  # username is alphanum, not empty, max 255, unique, lower case only
  VALID_USERNAME_REGEX = /\A[\w]+\z/i
  validates :username, presence: true, length: { maximum: 255 }, format: { with: VALID_USERNAME_REGEX }, uniqueness: { case_sensitive: false }

  # firstname is not empty, max 255
  validates :firstname, presence: true, length: { maximum: 255 }

  # lastname is not empty, max 255
  validates :lastname, presence: true, length: { maximum: 255 }

  # email is in the correct email format, not empty, unique, lower case only
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  # password is at least 6 characters long
  has_secure_password
  validates :password, length: { minimum: 6 }

  # New tokens for sessions
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  # Hash the given token
  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  # Save the hash of the new token
  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end
