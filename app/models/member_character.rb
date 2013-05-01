class MemberCharacter < ActiveRecord::Base
  belongs_to :member
  belongs_to :character
end
