class Message < ActiveRecord::Base
  attr_accessible :body, :match_id, :talk_key
  belongs_to :match, :dependent => :destroy

  validates :body, :presence => true
  validates :body, :length => { :minimum => 1, :maximum => 500 }

  def count_and_save(match)
    ActiveRecord::Base.transaction do
      self.save!
      pair = Match.find_by_id_and_profile_id(match.profile.user_id, match.user.profile.id)
      unless match.can_open_profile
        if match.messages.count > 2 && pair.messages.count > 2
          match.can_open_profile = true
          pair.can_open_profile = true
          match.save!
        end
      end
      pair.unread_count += 1
      pair.save!
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    self.errors.add :base, "internal_server_error"
    false
  end
end
