class SessionsController < ApplicationController
  before_action :require_logout, only: [:new, :create]

  def new
    redirect_to new_user_url
  end 
  
  def create
    user = User.find_by_credentials(params[:user][:username], params[:user][:password])
    if user
      login!(user)
      redirect_to cats_url
    else 
      flash.now[:errors] = ['Invalid Credentials!']
      render :new
    end
    
  end

  def destroy
    session[:session_token] = nil
    if current_user
      current_user.reset_session_token!
    end 
    redirect_to new_session_url
  end
end
