class MemberHobby < ActiveRecord::Base
  belongs_to :member
  belongs_to :hobby
end
