class Image < ActiveRecord::Base
  attr_accessible :user_id, :type, :order_number

  belongs_to :user
end
