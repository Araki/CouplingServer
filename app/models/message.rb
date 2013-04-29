class Message < ActiveRecord::Base
  attr_accessible :body, :match_id, :user_id, :target_id
  belongs_to :match
  belongs_to :user
  belongs_to :target, :class_name => 'User', :foreign_key => :target_id

  validates :body, :presence => true
  validates :body, :length => { :minimum => 1, :maximum => 500 }

  default_scope order('created_at DESC')

  scope :by_matches, lambda{|match_id, inverse_match_id|
    where(:match_id => [match_id, inverse_match_id])
  }

  scope :since, lambda{|since_id|
    where('id > ?', since_id) unless since_id.nil?
  }

  def save_message(match)
    ActiveRecord::Base.transaction do
      self.save!
      unless match.can_open_profile
        if match.messages.count > 2 && match.inverse.messages.count > 2
          match.can_open_profile = true
          match.inverse.can_open_profile = true
          match.save!
        end
      end
      match.inverse.save!
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    self.errors.add :base, "internal_server_error"
    false
  end
end
