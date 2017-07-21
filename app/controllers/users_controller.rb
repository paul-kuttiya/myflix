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

    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :source => params[:stripeToken],
        :description => "Charge for #{@user.email}"
      )

      if charge.successful?
        @user.save
        AppMailer.delay.send_welcome_email(@user.id)
        handle_invitation if @invitation
        log_in
      else
        flash[:danger] = charge.error_message
        render :new
      end
    else
      flash[:danger] = "Invalid user info please check the errors"
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

  def handle_invitation
    inviter = @invitation.inviter
    @user.follow(inviter)
    inviter.follow(@user)
    @invitation.update_column(:token, nil)
  end

  def log_in
    session[:user_id] = @user.id
    flash[:success] = "Welcome to myfix #{@user.full_name}!"
    redirect_to home_path
  end
end