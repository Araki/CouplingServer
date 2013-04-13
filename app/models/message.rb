class Message < ActiveRecord::Base
  attr_accessible :body, :match_id, :talk_key
  belongs_to :match, :dependent => :destroy

  validates :body, :presence => true
  validates :body, :length => { :minimum => 1, :maximum => 500 }

  def count_and_save(match)
    ActiveRecord::Base.transaction do
      self.save!
      unless match.can_open_profile
        if match.messages.count > 2 && match.pair.messages.count > 2
          match.can_open_profile = true
          match.save!
          match.pair.can_open_profile = true
          match.pair.save!
        end
      end
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    self.errors.add :base, "internal_server_error"
    false
  end
end
