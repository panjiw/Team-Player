#
# TeamPlayer -- 2014
#
# This file deals with creating a user and signing him in.
# It returns a status code indicating success or failure,
# as well as a list of reasons for failure if necessary
#
class UsersController < ApplicationController
  before_action :signed_in_user, only: [:viewgroup, :update]

  # Create a new user and sign user in
  def create

    @user = User.new(user_params)
    if @user.save
      # adding a self group
      @user.groups.create(name: 'Me', description: 'Assign task/bills to the Me group, if those task/bills are for yourself', 
              creator: @user.id, self: true)
      token = view_context.sign_in @user
      render :json => {:token => token}, :status => 200
    else
      render :json => @user.errors.full_messages, :status => 400
    end
  end

  # changes password (write in what it takes in / outputs)
  # Edit a signed-in user's information
  def edit_password
    @user = current_user
    if @user.authenticate(params[:edit][:password])
      userinfo = {:username => @user.username, :firstname => @user.firstname, :lastname => @user.lastname, :email => @user.email,
                             :password => params[:edit][:new_password], :password_confirmation => params[:edit][:new_password_confirmation]}
      if @user.update_attributes(userinfo)
        render :json => {}, :status => 200
      else
        render :json => @user.errors.full_messages, :status => 400
      end
    else
      render :json => "incorrect password", :status => 400
    end
  end

  # edit username
  def edit_username
    @user = current_user
    if @user.authenticate(params[:edit][:password])
      userinfo = {:username => params[:edit][:username], :firstname => @user.firstname, :lastname => @user.lastname, :email => @user.email,
                             :password => params[:edit][:password], :password_confirmation => params[:edit][:password]}
      if @user.update_attributes(userinfo)
        render :json => {}, :status => 200
      else
        render :json => @user.errors.full_messages, :status => 400
      end
    else
      render :json => "incorrect password", :status => 400
    end
  end

  # edit name
  def edit_name
    @user = current_user
    if @user.authenticate(params[:edit][:password])
      userinfo = {:username => @user.username, :firstname => params[:edit][:firstname], :lastname => params[:edit][:lastname], :email => @user.email,
                             :password => params[:edit][:password], :password_confirmation => params[:edit][:password]}
      if @user.update_attributes(userinfo)
        render :json => {}, :status => 200
      else
        render :json => @user.errors.full_messages, :status => 400
      end
    else
      render :json => "incorrect password", :status => 400
    end
  end

  # edit email
  def edit_email
    @user = current_user
    if @user.authenticate(params[:edit][:password])
      userinfo = {:username => @user.username, :firstname => @user.firstname, :lastname => @user.lastname, :email => params[:edit][:email],
                             :password => params[:edit][:password], :password_confirmation => params[:edit][:password]}
      if @user.update_attributes(userinfo)
        render :json => {}, :status => 200
      else
        render :json => @user.errors.full_messages, :status => 400
      end
    else
      render :json => "incorrect password", :status => 400
    end
  end

  # Updates user information after editting
  # If update is successful, status 200. 
  # Else, status 400
  def update

    @user = current_user
    if @user.update_attributes(user_params)
      render :json => {}, :status => 200
    else
      render :json => @user.errors.full_messages, :status => 400
    end
  end


  # find user by email
  def finduseremail
    @user = User.where("email = ?", params[:find][:email])
    if !@user.empty?
      render :json => @user.first.to_json(:except => [:created_at, :updated_at, 
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
  
  #viewgroup-> give all groups login user is in, and for each group includes all
  # t he users of that group, excluding private infos
  def viewgroup
    groups = current_user.groups
    render :json => groups.to_json(:include => [:users => {:except => [:created_at, :updated_at, 
			:password_digest, :remember_token]}]), :status => 200
  end



  private

  # Make sure the params sent in is valid (see User Rep Inv)
  def user_params
    params.require(:user).permit(:username, :firstname, :lastname, :email, :password, :password_confirmation)
  end

  # Requires sigged-in user
  def signed_in_user
      redirect_to '/', notice: "Please sign in." unless signed_in?
  end


end
