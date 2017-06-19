class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  def ratings
    review = video.reviews.find_by(user: user)
    review ? review.ratings : nil
  end

  def category_name
    category.name
  end
end