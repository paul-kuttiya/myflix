class SessionsController < ApplicationController
  before_action :send_home, only: [:new]

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome back #{user.full_name}!"
      redirect_to home_path
    else
      flash[:danger] = "Invalid email or password."
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:danger] = "You are signed out!"
    redirect_to root_path
  end
end