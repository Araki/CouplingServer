class UserHobby < ActiveRecord::Base
  belongs_to :user,  :dependent => :destroy
  belongs_to :hobby, :dependent => :destroy
end
