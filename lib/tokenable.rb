module Tokenable
  extend ActiveSupport::Concern

  module ClassMethods
    def generate_token
      token = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless exists?(token: random_token)
      end
    end
  end

  def generate_token
    self.token = self.class.generate_token
  end
end