class Session < ActiveRecord::Base
  attr_accessible :key, :value

  class << self
    def create_session
      session = Session.new
      session.key = SecureRandom.urlsafe_base64(12 * 3 / 4)
      session.value = @user.id
      session.save!
      session
    end
  end
end
