class Relation < ActiveRecord::Base
  attr_accessible :type, :target_id, :user_id

  belongs_to :user
  belongs_to :target, :class_name => "User", :foreign_key => "target_id"

  default_scope order('created_at DESC')

  # validates :user_id, :uniqueness => {:scope => :target_id }

  def inverse
    self.class.find_by_user_id_and_target_id(self.target_id, self.user_id)
  end
end