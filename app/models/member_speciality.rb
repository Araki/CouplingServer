class MemberSpeciality < ActiveRecord::Base
  belongs_to :member,  :dependent => :destroy
  belongs_to :speciality, :dependent => :destroy
end
