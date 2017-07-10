class PasswordResetsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])

    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end
  
  def create
    user = User.find_by(token: params[:token])

    if user
      user.update_attributes(password: params[:password], token: nil)
      user.save
      
      flash[:success] = "Please sign in with your new password!"
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end
end