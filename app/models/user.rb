class User < ActiveRecord::Base
  before_save {
    self.username = username.downcase
    self.email = email.downcase
  }
  before_create :create_remember_token

  VALID_USERNAME_REGEX = /\A[\w]+\z/i
  validates :username, presence: true, length: { maximum: 255 }, format: { with: VALID_USERNAME_REGEX }, uniqueness: { case_sensitive: false }
  validates :firstname, presence: true, length: { maximum: 255 }
  validates :lastname, presence: true, length: { maximum: 255 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

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
