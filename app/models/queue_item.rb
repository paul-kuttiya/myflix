class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :list_order, {only_integer: true}

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  def ratings
    review ? review.ratings : nil
  end

  def ratings=(new_ratings)
    if review
      review.update_column(:ratings, new_ratings)
      return
    end

    review = Review.new(user: user, video: video, ratings: new_ratings)
    review.save(validate: false)
  end

  def category_name
    category.name
  end

  private
  def review
    @review ||= Review.find_by(user: user, video: video)
  end
end