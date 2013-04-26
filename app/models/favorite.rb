class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :profile

  default_scope order('created_at DESC')
end
