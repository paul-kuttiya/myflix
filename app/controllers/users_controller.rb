class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user].permit!)

    if @user.save
      flash[:success] = "Welcome to myfix #{@user.full_name}!"
      redirect_to home_path
    else
      render :new
    end
  end
end