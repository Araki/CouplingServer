# coding:utf-8
class Member < ActiveRecord::Base
  attr_accessible :type, :blood_type, :group_id,
    :holiday, :income, :industry, :introduction, :job, 
    :nickname, :prefecture,
    :proportion, :school, :smoking, :status

  belongs_to :group

  has_one  :main_image, :class_name => "Image", :conditions => { :is_main => true }
  has_many :images, :dependent => :delete_all

  has_many :member_hobbies
  has_many :hobbies, :through => :member_hobbies
  has_many :member_specialities
  has_many :specialities, :through => :member_specialities
  has_many :member_characters
  has_many :characters, :through => :member_characters

  validates :type, :inclusion => { :in => ['Friend','Profile'] }, :presence => true
  validates :age, :presence => true
  validates :gender, 
    :presence => true,
    :inclusion => { :in => [0, 1] }
  validates :nickname, 
    :presence => true,
    :length => { :minimum => 1, :maximum => 50 }

  validates :prefecture, :inclusion => { :in => 1..47 }, :allow_nil => true
  validates :holiday, :inclusion => { :in => 0..3 }, :allow_nil => true
  validates :income, :inclusion => { :in => 0..7 }, :allow_nil => true
  validates :introduction, :length => { :minimum => 70, :maximum => 500 }, :allow_nil => true
  validates :proportion, :inclusion => { :in => 0..7 }, :allow_nil => true

  def set_main_image(image)
    ActiveRecord::Base.transaction do
      self.main_image.update_attribute(:is_main, false ) if self.main_image.present?
      image.update_attribute(:is_main, true )
    end
      return true
    rescue => e
      return false
  end

  def as_json(options = {})
      json = super(options)
      json['images'] = self.images.as_json
      json['hobbies'] = self.hobbies.as_json
      json['specialities'] = self.specialities.as_json
      json['characters'] = self.characters.as_json
      json
  end  

end
