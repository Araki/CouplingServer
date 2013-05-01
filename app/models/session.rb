class Session < ActiveRecord::Base
  attr_accessible :key, :value
  default_scope order('created_at DESC')

  validates :key, :presence => true
  validates :value, :presence => true
  
  class << self
    def create_session(user)
      Session.create!({
        key: SecureRandom.urlsafe_base64(12 * 3 / 4),
        value: user.id
        })
    end
  end
end
