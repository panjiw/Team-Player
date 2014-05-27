# Functions for sessions
module SessionsHelper
  # Signs in the given user
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
    self.current_user = user
    remember_token
  end

  # Uodates the current user to the given user
  def current_user=(user)
    @current_user = user
  end

  # Returns the user currently signed in
  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  # Returns whether the user is signed in
  def signed_in?
    !current_user.nil?
  end

  # Signs out the given user
  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end


  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      # store_location
      # redirect_to signin_url, notice: "Please sign in."
      redirect_to '/', notice: "Please sign in." unless signed_in?
    end
  end

end
