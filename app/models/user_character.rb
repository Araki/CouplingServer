class UserCharacter < ActiveRecord::Base
  belongs_to :user,  :dependent => :destroy
  belongs_to :character, :dependent => :destroy
end
