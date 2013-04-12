# coding:utf-8
class Member < ActiveRecord::Base
  attr_accessible :alcohol, :birthplace, :blood_type, :character, :group_id,
    :dislike, :height, :holiday, :income, :industry, :introduction, :job, 
    :job_description, :marital_history, :marriage_time, :nickname, :prefecture,
    :proportion, :roommate, :school, :smoking, :sociability, :workplace

  belongs_to :group

  has_many :member_hobbies
  has_many :hobbies, :through => :member_hobbies
  has_many :member_specialities
  has_many :specialities, :through => :member_specialities
  has_many :member_characters
  has_many :characters, :through => :member_characters

  validates :age, :presence => true
  validates :gender, 
    :presence => true,
    :inclusion => { :in => [0, 1] }
  validates :nickname, 
    :presence => true,
    :length => { :minimum => 1, :maximum => 50 }

  validates :alcohol, :inclusion => { :in => 0..3 }, :allow_nil => true
  validates :birthplace, :inclusion => { :in => 1..47 }, :allow_nil => true
  validates :prefecture, :inclusion => { :in => 1..47 }, :allow_nil => true
  # validates :character, :inclusion => { :in => 0..46 }, :allow_nil => true
  validates :holiday, :inclusion => { :in => 0..3 }, :allow_nil => true
  validates :income, :inclusion => { :in => 0..7 }, :allow_nil => true
  validates :introduction, :length => { :minimum => 70, :maximum => 500 }, :allow_nil => true
  validates :height, :inclusion => { :in => 130..210 }, :allow_nil => true
  validates :proportion, :inclusion => { :in => 0..7 }, :allow_nil => true
  # validates :roommate, :inclusion => { :in => 0..3 }, :allow_nil => true
  validates :smoking, :inclusion => { :in => 0..2 }, :allow_nil => true


  def as_json(options = {})
      json = super(options)
      # json['images'] = self.images.as_json
      json
  end  

end
