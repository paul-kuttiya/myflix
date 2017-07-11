class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: "User"
  validates_presence_of :recipient_name, :recipient_email, :message

  before_create :generate_token

  def generate_token
    self.token = self.class.generate_token
  end

  private
  def self.generate_token
    token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless exists?(token: random_token)
    end
  end
end