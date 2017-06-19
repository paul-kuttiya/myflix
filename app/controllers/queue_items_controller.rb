class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = QueueItem.where(user: current_user)
  end

  def create
    @video = Video.find(params[:video_id])
    @queue_item = QueueItem.new(user: current_user, video_id: @video.id)

    if existing_queue
      flash[:danger] = "Video already exists in queue!"
      redirect_to @video
    else
      @queue_item.save
      redirect_to my_queue_path
    end
  end

  def destroy
    @queue_item = QueueItem.find(params[:id])

    if @queue_item.destroy
      update_list
      redirect_to my_queue_path
    end
  end

  private
  def existing_queue
    current_user.queue_items.find_by(video_id: params[:video_id])
  end

  def update_list
    current_user.queue_items.where("list_order > ?", @queue_item.list_order)
                .update_all("list_order = list_order - 1")
  end
end