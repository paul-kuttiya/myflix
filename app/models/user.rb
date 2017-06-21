class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order("list_order") }

  has_secure_password validation: false
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email
end