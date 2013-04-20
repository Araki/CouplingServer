class Like < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  belongs_to :profile, :dependent => :destroy

  # validates :user_id, :uniqueness => {:scope => :target_id }
end
