class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  before_save :increment_list_order

  def ratings
    review = video.reviews.find_by(user: user)
    review ? review.ratings : nil
  end

  def category_name
    category.name
  end

  def increment_list_order
    self.list_order = user.queue_items.size + 1
  end
end