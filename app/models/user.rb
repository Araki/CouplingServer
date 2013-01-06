class User < ActiveRecord::Base
  attr_accessible :access_token, :address, :age, :alcohol, :birthplace, :blood_type, :certification, :certification_status, :character, :constellation, :contract_type, :country, :dislike, :email, :facebook_id, :first_login_at, :gender, :have_child, :height, :hobby, :holiday, :income, :industry, :introduction, :invitation_code, :job, :job_description, :language, :last_login_at, :like_point, :main_picture, :marital_history, :marriage_time, :nickname, :point, :profile_status, :proportion, :public_status, :qualification, :relationship, :roommate, :school, :smoking, :sociability, :speciality, :sub_picture1, :sub_picture2, :sub_picture3, :sub_picture4, :want_child, :workplace

  has_many :pictures, :dependent => :delete_all

  def to_hash
    {
      :id => self.id,
      :facebook_id => self.facebook_id,
      :profile_status => self.profile_status,
      :email => self.email,
      :certification => self.certification,
      :certification_status => self.certification_status,
      :public_status => self.public_status,
      :first_login_at => self.first_login_at,
      :last_login_at => self.last_login_at,
      :invitation_code => self.invitation_code,
      :contract_type => self.contract_type,
      :like_point => self.like_point,
      :point => self.point,
      :nickname => self.nickname,
      :introduction => self.introduction,
      :gender => self.gender,
      :age => self.age,
      :country => self.country,
      :language => self.language,
      :address => self.address,
      :birthplace => self.birthplace,
      :roommate => self.roommate,
      :height => self.height,
      :proportion => self.proportion,
      :constellation => self.constellation,
      :blood_type => self.blood_type,
      :marital_history => self.marital_history,
      :marriage_time => self.marriage_time,
      :want_child => self.want_child,
      :relationship => self.relationship,
      :have_child => self.have_child,
      :smoking => self.smoking,
      :alcohol => self.alcohol,
      :industry => self.industry,
      :job => self.job,
      :job_description => self.job_description,
      :workplace => self.workplace,
      :income => self.income,
      :qualification => self.qualification,
      :school => self.school,
      :holiday => self.holiday,
      :sociability => self.sociability,
      :character => self.character,
      :speciality => self.speciality,
      :hobby => self.hobby,
      :dislike => self.dislike,
      :login_token => self.login_token,
      :created_at => self.created_at,
      :updated_at => self.updated_at
    }
  end
end
