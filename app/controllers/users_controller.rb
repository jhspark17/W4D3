class UsersController < ApplicationController
  before_action

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

   if @user.save!
    render user_url
   else
    @user.errors.full_messages
   end
  end


  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end