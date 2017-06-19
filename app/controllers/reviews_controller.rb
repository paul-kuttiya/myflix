class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.build(create_review.merge!(user: current_user))
    
    if @review.save
      redirect_to @video
    else
      #validates false and @review returns nil
      #need reviews array to display existing reviews
      #will get error for nil review in reviews arr, ie review.create_at ~> nil.created_at
      #need reload to refresh instance, get rid of that @review in @video.reviews

      @video.reload
      render 'videos/show'
    end
  end

  private
  def create_review
    params.require(:review).permit!
  end
end