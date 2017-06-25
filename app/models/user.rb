class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order(list_order: :asc) }

  has_secure_password validation: false
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  def normalize_queue_position
    self.queue_items.each_with_index do |queue, idx|
      queue.update_attributes(list_order: idx + 1)
    end
  end

  def already_queued?(video)
    self.queue_items.map(&:video).include?(video)
  end
end