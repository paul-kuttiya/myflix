class Video < ActiveRecord::Base
  has_many :reviews, -> { order("created_at DESC") }
  has_many :queue_items
  belongs_to :category
  validates_presence_of :title, :description

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def average_ratings
    ratings = self.reviews.map(&:ratings)
    return false if ratings.length == 0
    (ratings.inject(:+) / ratings.length).round(1)
  end
end
