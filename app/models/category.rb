class Category < ActiveRecord::Base
  has_many :videos, -> {order("title")}
  default_scope { order("name") }

  def to_param
    self.name
  end

  def recent_videos(limit=6)
    videos.limit(limit).reorder("created_at DESC")
  end
end