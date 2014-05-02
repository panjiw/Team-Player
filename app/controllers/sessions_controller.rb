class SessionsController < ApplicationController
  protect_from_forgery with: :exception
  include SessionsHelper

  def create
    user = User.find_by(username: params[:user][:username].downcase)
    if user && user.authenticate(params[:user][:password])
      token = sign_in user
      render plain: token
    else
      render plain: @user.errors.full_messages
    end
  end

  def destroy
    sign_out
    #redirect_to '/'
    # Send message
  end
end
