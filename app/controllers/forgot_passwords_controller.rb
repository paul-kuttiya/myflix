class ForgotPasswordsController < ApplicationController
  before_action :send_home
  
  def create
    user = User.find_by(email: params[:email])

    if user
      user.update_column(:token, User.get_token)
      AppMailer.delay.send_forgot_password(user.id)
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email].blank? ?  "Invalid inputs!" : "Email does not exist"
      redirect_to forgot_password_path
    end
  end
end