class Message < ActiveRecord::Base
  attr_accessible :body, :match_id, :user_id

  belongs_to :match
  belongs_to :user

  validates :body, :presence => true, :length => { :minimum => 1, :maximum => 500 }

  default_scope order('created_at DESC')

  scope :by_matches, lambda{|match_id, inverse_match_id| where(:match_id => [match_id, inverse_match_id])}
  scope :since, lambda{|since_id| where('id > ?', since_id) unless since_id.nil? }
  scope :after_created_at, lambda{|check_at| where("created_at > ?", check_at) unless check_at.nil?}

  def save_message(match)
    ActiveRecord::Base.transaction do
      self.save!
      unless match.can_open_profile
        inverse_match = match.inverse
        if match.messages.count > 2 && inverse_match.messages.count > 2
          match.can_open_profile = true
          inverse_match.can_open_profile = true
          match.save!
          inverse_match.save!
        end
      end
    end
  end
end
