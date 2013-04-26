class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile

  default_scope order('created_at DESC')

  # validates :user_id, :uniqueness => {:scope => :target_id }
end
