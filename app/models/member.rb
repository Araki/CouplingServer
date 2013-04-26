# coding:utf-8
require 'model_helper'

class Member < ActiveRecord::Base
  include ModelHelper
  
  attr_accessible :type, :alcohol, :birthplace, :blood_type, :character, :group_id,
    :dislike, :height, :holiday, :income, :industry, :introduction, :job, 
    :job_description, :marital_history, :marriage_time, :nickname, :prefecture,
    :proportion, :roommate, :school, :smoking, :sociability, :workplace, :status
  attr_accessible :type, :alcohol, :birthplace, :blood_type, :character, :group_id,
    :dislike, :height, :holiday, :income, :industry, :introduction, :job, 
    :job_description, :marital_history, :marriage_time, :nickname, :prefecture,
    :proportion, :roommate, :school, :smoking, :sociability, :workplace, :status,
    :gender, :age, :like_point, :birthday_on, :as => :admin  

  belongs_to :group

  has_one  :main_image, :class_name => "Image", :conditions => { :is_main => true }, :dependent => :destroy
  has_many :images, :dependent => :delete_all

  has_many :member_hobbies, :dependent => :destroy
  has_many :hobbies, :through => :member_hobbies
  has_many :member_specialities, :dependent => :destroy
  has_many :specialities, :through => :member_specialities
  has_many :member_characters, :dependent => :destroy
  has_many :characters, :through => :member_characters

  default_scope order('created_at DESC')

  scope :by_statuses, lambda{|statuses| where(status: statuses) unless statuses.nil?}
  # scope :by_gender, lambda{|user|
  #   gender = user.profile.gender == 0 ? 1 : 0
  #   where(gender: gender)
  # }
  scope :by_gender, lambda{|gender| where(gender: gender) unless gender.nil?}
  scope :by_max_height, lambda{|height| where("height < ?", height) unless height.nil?}
  scope :by_min_height, lambda{|height| where("height > ?", height) unless height.nil?}
  scope :by_income, lambda{|income| where("income > ?", income) unless income.nil?}
  scope :by_blood_type, lambda{|blood_type| where(blood_type: blood_type) unless blood_type.nil?}
  scope :by_jobs, lambda{|jobs| where(job: jobs) unless jobs.nil?}
  scope :by_prefectures, lambda{|prefectures| where(prefecture: prefectures) unless prefectures.nil?}
  scope :by_proportions, lambda{|proportions| where(proportion: proportions) unless proportions.nil?}
  scope :by_roommates, lambda{|roommates| where(roommate: roommates) unless roommates.nil?}
  scope :by_smokings, lambda{|smokings| where(smoking: smokings) unless smokings.nil?}
  scope :by_sociabilities, lambda{|sociabilities| where(sociability: sociabilities) unless sociabilities.nil?}
  scope :by_school, lambda{|school| where("school > ?", school) unless school.nil?}
  scope :by_hobbies, lambda{|hobbies|
    joins(:hobbies).where("hobbies.id" => hobbies) unless hobbies.nil?
  }
  scope :by_specialities, lambda{|specialities|
    joins(:specialities).where("specialities.id" => specialities) unless specialities.nil?
  }
  scope :by_characters, lambda{|characters|
    joins(:characters).where("characters.id" => characters) unless characters.nil?
  }

  validates :type, :inclusion => { :in => ['Friend','Profile'] }, :presence => true
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

  def self.search(params)
    self.by_statuses(params[:member_status]).by_gender(params[:gender]).by_max_height(params[:max_height]).
      by_min_height(params[:min_height]).by_income(params[:income]).by_blood_type(params[:blood_type]).by_jobs(params[:jobs]).
      by_proportions(params[:proportions]).by_roommates(params[:roommates]).by_smokings(params[:smokings]).
      by_sociabilities(params[:sociabilities]).by_school(params[:school]).by_hobbies(params[:hobbies]).
      by_specialities(params[:specialities]).by_characters(params[:characters]).order('id desc')
  end

  def set_main_image(image)
    ActiveRecord::Base.transaction do
      self.main_image.update_attribute(:is_main, false ) if self.main_image.present?
      image.update_attribute(:is_main, true )
    end
      return true
    rescue => e
      return false
  end

  def save_profile(params)
    prop = self.class.name.underscore.to_sym
    self.class.transaction do
      if self.persisted?
        self.update_attributes!(params[prop])
      else
        self.save!
      end
      [:hobbies, :characters, :specialities].each{|association| update_associations(association, params)}
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    false
  rescue => e
    self.errors.add :base, e.message
    false
  end

  def update_profile_by_admin(params)
    prop = self.class.name.underscore.to_sym
    [:hobbies, :characters, :specialities].each do |association|
      ids = (association.to_s.singularize + '_ids').to_sym
      if params[prop][ids]
        params[association] = params[prop][ids] 
        params[prop].delete(ids)
        params[association].delete('')
      end
    end    
    self.class.transaction do
      self.assign_attributes(params[prop], :as => :admin)
      self.save!
      [:hobbies, :characters, :specialities].each{|association| update_associations(association, params)}
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    false
  rescue => e
    self.errors.add :base, e.message
    false
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
