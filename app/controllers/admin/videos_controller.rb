class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(create_video)

    if @video.save
      flash[:success] = "Successfully save #{@video.title}!"
      redirect_to new_admin_video_path
    else
      render :new
    end
  end

  private
  def create_video
    params.require(:video).permit!
  end
end