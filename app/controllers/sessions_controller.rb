class SessionsController < ApplicationController
  protect_from_forgery with: :exception
  include SessionsHelper

  def create
    user = User.find_by(username: params[:user][:username].downcase)
    if user && user.authenticate(params[:user][:password])
      token = sign_in user
      render :json => {:token => token}, :status => 200
    else
      render :json => {:errors => "Wrong user name or password"}, :status => 400
    end
  end

  def user
    if signed_in?
      render :json => {:username => current_user.username, :firstname => current_user.firstname, :lastname => current_user.lastname, :id => current_user.id}, :status => 200
    else
      redirect_to '/'
    end
  end

  def destroy
    sign_out
    render :json => {}, :status => 200
  end
end