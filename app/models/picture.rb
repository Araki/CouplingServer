class Picture < ActiveRecord::Base
  attr_accessible :is_main, :name, :user_id

  belongs_to :user
end
