class UsersController < ApplicationController
  before_action :send_home, only: [:new]
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def register_with_invitation
    @invitation = Invitation.find_by(token: params[:token])

    if @invitation
      @user = User.new(email: @invitation.recipient_email)
      @invitation_token = @invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(create_user)
    @invitation = Invitation.find_by(token: params[:invitation_token])
    
    result = UserSignup.new(@user).signup(@invitation, params[:stripeToken])

    if result.successful?
      log_in(result.user)
    else
      flash[:danger] = result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
  def create_user
    params.require(:user).permit!
  end

  def log_in(user)
    session[:user_id] = user.id
    flash[:success] = "Welcome to myfix #{user.full_name}!"
    redirect_to home_path
  end
end