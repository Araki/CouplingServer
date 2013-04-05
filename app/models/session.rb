class Session < ActiveRecord::Base
  attr_accessible :key, :value

  class << self
    def create_session(user)
      Session.create!({
        key: SecureRandom.urlsafe_base64(12 * 3 / 4),
        value: user.id
        })
    end
  end
end
