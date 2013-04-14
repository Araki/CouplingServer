class MemberCharacter < ActiveRecord::Base
  belongs_to :member,  :dependent => :destroy
  belongs_to :character, :dependent => :destroy
end
