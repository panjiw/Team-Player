class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render plain: "OK"
    else
      render plain: @user.errors.full_messages
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :firstname, :lastname, :email, :password, :password_confirmation)
  end
end
