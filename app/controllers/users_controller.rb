class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      token = view_context.sign_in @user
      render :json => {:token => token}, :status => 200
    else
      render :json => {:errors => @user.errors.full_messages}, :status => 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :firstname, :lastname, :email, :password, :password_confirmation)
  end
end
