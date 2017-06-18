class UsersController < ApplicationController
  before_action :send_home, only: [:new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_user)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to myfix #{@user.full_name}!"
      redirect_to home_path
    else
      render :new
    end
  end

  private
  def create_user
    params.require(:user).permit!
  end
end