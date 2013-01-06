class Like < ActiveRecord::Base
  attr_accessible :target_id, :user_id

  def to_hash
    {
      :id => self.id,
      :user_id => self.user_id,
      :target_id => self.target_id,
      :created_at => self.created_at,
      :updated_at => self.updated_at
    }
  end
end
