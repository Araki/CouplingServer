class Like < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  belongs_to :target_user, :class_name => "User", :foreign_key => "target_id", :dependent => :destroy

  # validates :user_id, :uniqueness => {:scope => :target_id }
end
