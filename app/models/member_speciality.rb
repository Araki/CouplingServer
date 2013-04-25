class MemberSpeciality < ActiveRecord::Base
  belongs_to :member
  belongs_to :speciality
end
