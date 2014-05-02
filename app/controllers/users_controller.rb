class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      view_context.sign_in @user
      #render plain: "OK"
      #redirect_to '/home'
      # Send message
    else
      render plain: @user.errors.full_messages
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :firstname, :lastname, :email, :password, :password_confirmation)
  end
end
