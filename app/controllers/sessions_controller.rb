# Controls sessions
class SessionsController < ApplicationController
  protect_from_forgery with: :exception
  include SessionsHelper

  # Sign in
  def create
    user = User.find_by(username: params[:user][:username].downcase)
    if user && user.authenticate(params[:user][:password])
      token = sign_in user
      render :json => {:token => token}, :status => 200
    else
      render :json => {:errors => ["Wrong user name or password"]}, :status => 400
    end
  end

  # Get signed in user data
  def user
    if signed_in?
      render :json => {:username => current_user.username, :firstname => current_user.firstname, :lastname => current_user.lastname, :id => current_user.id}, :status => 200
    else
      redirect_to '/'
    end
  end

  # Sign out
  def destroy
    sign_out
    render :json => {}, :status => 200
  end
end