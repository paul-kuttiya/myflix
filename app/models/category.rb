class Category < ActiveRecord::Base
  has_many :videos, -> {order("title")}

  default_scope { order("name") }

  def to_param
    self.name
  end
end