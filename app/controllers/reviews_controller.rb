class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.build(create_review.merge!(user: current_user))
    
    if @review.save
      redirect_to @video
    else
      #validates false and returns nil
      #need reload to get all @video data again
      @video.reload
      render 'videos/show'
    end
  end

  private
  def create_review
    params.require(:review).permit!
  end
end