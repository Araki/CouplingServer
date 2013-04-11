class UserSpeciality < ActiveRecord::Base
  belongs_to :user,  :dependent => :destroy
  belongs_to :speciality, :dependent => :destroy
end
