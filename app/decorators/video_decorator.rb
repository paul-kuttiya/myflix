class VideoDecorator < Draper::Decorator
  delegate_all
  
  def rating
    object.average_ratings.present? ? "Ratings: #{object.average_ratings} / 5.0" : "No Reviews"
  end
end