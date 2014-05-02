# User model, saves uer data to db
class User < ActiveRecord::Base
  before_save {
    self.username = username.downcase
    self.email = email.downcase
  }
  before_create :create_remember_token

  # Rep Inv

  # username is alphanum, not empty, max 255, unique, down case only
  VALID_USERNAME_REGEX = /\A[\w]+\z/i
  validates :username, presence: true, length: { maximum: 255 }, format: { with: VALID_USERNAME_REGEX }, uniqueness: { case_sensitive: false }

  # firstname is not empty, max 255
  validates :firstname, presence: true, length: { maximum: 255 }

  # lastname is not empty, max 255
  validates :lastname, presence: true, length: { maximum: 255 }

  # email is in the correct email format, not empty, unique, down case only
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 6 }

  # New tokens for sessions
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end
