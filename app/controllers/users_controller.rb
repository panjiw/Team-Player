#
# TeamPlayer -- 2014
#
# This file deals with creating a user and signing him in.
# It returns a status code indicating success or failure,
# as well as a list of reasons for failure if necessary
#
class UsersController < ApplicationController
  # Create a new user and sign user in
  def create
    @user = User.new(user_params)
    if @user.save
      token = view_context.sign_in @user
      render :json => {:token => token}, :status => 200
    else
      render :json => {:errors => @user.errors.full_messages}, :status => 400
    end
  end
  
  # find user by email
  def finduseremail
    @user = User.where("email = ?", params[:find][:email])
    if !@user.nil?
      render :json => @user.to_json(:except => [:created_at, :updated_at, 
			:password_digest, :remember_token]), :status => 200

#:json => {:user =>  @user :except=>
# 			[:created_at, :updated_at, 
#			:password_digest, :remember_token]
#		      }
#, :status => 200
    else
      render :nothing => true, :status => 400
    end
  end

  private

  # Make sure the params sent in is valid (see User Rep Inv)
  def user_params
    params.require(:user).permit(:username, :firstname, :lastname, :email, :password, :password_confirmation)
  end
end
