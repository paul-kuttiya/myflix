class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    @video = Video.find(params[:video_id])
    @queue_item = QueueItem.new(user: current_user, video_id: @video.id)
    
    if existing_queue
      flash[:danger] = "Video already exists in queue!"
      redirect_to @video
    else
      increment_list_order(@queue_item)
      @queue_item.save
      redirect_to my_queue_path
    end
  end

  def destroy
    @queue_item = QueueItem.find(params[:id])

    @queue_item.destroy if current_user.queue_items.include?(@queue_item)
    current_user.normalize_queue_position
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_item
      current_user.normalize_queue_position
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "List order must be a number!"
    end

    redirect_to my_queue_path
  end

  private
  def existing_queue
    current_user.queue_items.find_by(video_id: params[:video_id])
  end

  def increment_list_order(queue_item)
    queue_item.list_order = current_user.queue_items.size + 1 if current_user
  end

  def update_queue_item
    queues_arr = params[:queue_items]
    ActiveRecord::Base.transaction do
      queues_arr.each do |queue|
        queue_item = QueueItem.find(queue["id"])
        queue_item.update_attributes!(list_order: queue["list_order"], ratings: queue["ratings"]) if current_user == queue_item.user
      end
    end
  end
end