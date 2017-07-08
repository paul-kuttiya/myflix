class User < ActiveRecord::Base
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order(list_order: :asc) }
  has_many :following_relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :leading_relationships, class_name: "Relationship", foreign_key: "leader_id"

  has_secure_password validation: false
  validates_presence_of :email, :password, :full_name, on: [:create]
  validates_uniqueness_of :email

  before_create :generate_token

  def normalize_queue_position
    self.queue_items.each_with_index do |queue, idx|
      queue.update_attributes(list_order: idx + 1)
    end
  end

  def already_queued?(video)
    self.queue_items.map(&:video).include?(video)
  end

  def follow?(another_user)
    self.following_relationships.map(&:leader).include?(another_user)
  end

  def can_follow?(another_user)
    !(self.follow?(another_user) || (self == another_user))
  end

  def to_param
    token
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end