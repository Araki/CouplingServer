class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile

  # validates :user_id, :uniqueness => {:scope => :target_id }
end
