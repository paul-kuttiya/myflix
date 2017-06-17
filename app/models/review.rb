class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  default_scope { order("created_at DESC") }
end