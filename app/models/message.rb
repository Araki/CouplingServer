class Message < ActiveRecord::Base
  attr_accessible :body, :match_id, :talk_key
  belongs_to :match, :dependent => :destroy, :counter_cache => true

  validates :body, :presence => true
  validates :body, :length => { :minimum => 1, :maximum => 500 }
end
