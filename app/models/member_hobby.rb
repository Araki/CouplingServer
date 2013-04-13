class MemberHobby < ActiveRecord::Base
  belongs_to :member,  :dependent => :destroy
  belongs_to :hobby, :dependent => :destroy
end
