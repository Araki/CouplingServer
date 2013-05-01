# coding:utf-8
require 'model_helper'

class Group < ActiveRecord::Base
  include ModelHelper
  attr_accessible :gender, :max_age, :min_age, :head_count, :relationship, 
    :request, :opening_hour, :target_age_range, :area, :user_id, :status

  belongs_to  :leader, :class_name => 'User', :foreign_key => :user_id, :include => [{:profile => [:images, :hobbies, :characters, :specialities]}]
  has_many :friends, :include => [:images, :hobbies, :characters, :specialities]
  has_many :members, :include => [:images, :hobbies, :characters, :specialities]

  has_many :group_group_images
  has_many :group_images, :through => :group_group_images
  has_many :group_days
  has_many :days, :through => :group_days
  has_many :group_mst_prefectures
  has_many :mst_prefectures, :through => :group_mst_prefectures

  scope :by_statuses, lambda{|statuses| where(status: statuses) unless statuses.nil?}
  # scope :by_gender, lambda{|user|
  #   gender = user.profile.gender == 0 ? 1 : 0
  #   where(gender: gender)
  # }
  scope :by_gender, lambda{|gender| where(gender: gender) unless gender.nil?}
  scope :by_max_age, lambda{|age| where("max_age < ?", age) unless age.nil?}
  scope :by_min_age, lambda{|age| where("min_age > ?", age) unless age.nil?}
  scope :by_head_count, lambda{|head_count| where(head_count: head_count) unless head_count.nil?}
  scope :by_group_images, lambda{|group_images|
    includes(:group_images).where("group_images.id" => group_images) unless group_images.nil?
  }
  scope :by_days, lambda{|days|
    includes(:days).where("days.id" => days) unless days.nil?
  }
  scope :by_mst_prefectures, lambda{|mst_prefectures|
    includes(:mst_prefectures).where("mst_prefectures.id" => mst_prefectures) unless mst_prefectures.nil?
  }


  validates :max_age, :inclusion => { :in => 0..100 }, :presence => true
  validates :min_age, :inclusion => { :in => 0..100 }, :presence => true
  validates :head_count, :inclusion => { :in => 0..10 }, :presence => true

  # validates :opening_hour, :allow_nil => true
  validates :relationship, :length => { :maximum => 50 }, :allow_nil => true
  validates :request, :length => { :maximum => 500 }, :allow_nil => true
  validates :target_age_range, :inclusion => { :in => 0..10 }, :allow_nil => true
  validates :area, :length => { :maximum => 50 }, :allow_nil => true

  def self.search(params)
    if member_params_exists?(params)
      self.by_statuses(params[:group_status]).by_gender(params[:gender]).by_max_age(params[:max_age]).by_min_age(params[:min_age]).
        by_head_count(params[:head_count]).by_group_images(params[:group_images]).by_days(params[:days]).
        by_mst_prefectures(params[:mst_prefectures]).
        where({
          id: Member.select("group_id").by_statuses(params[:member_status]).by_gender(params[:gender]).by_max_height(params[:max_height]).
            by_min_height(params[:min_height]).by_income(params[:income]).by_blood_type(params[:blood_type]).by_jobs(params[:jobs]).
            by_proportions(params[:proportions]).by_roommates(params[:roommates]).by_smokings(params[:smokings]).
            by_sociabilities(params[:sociabilities]).by_school(params[:school]).by_hobbies(params[:hobbies]).
            by_specialities(params[:specialities]).by_characters(params[:characters])
        })
    else
      self.by_statuses(params[:group_status]).by_gender(params[:gender]).by_max_age(params[:max_age]).by_min_age(params[:min_age]).
        by_head_count(params[:head_count]).by_group_images(params[:group_images]).by_days(params[:days]).
        by_mst_prefectures(params[:mst_prefectures])
    end
  end

# .includes([:group_images, :mst_prefectures, :days ,:friends => [:images, :hobbies, :characters, :specialities],:leader => [:images, :hobbies, :characters, :specialities]])
# .includes([:group_images, :mst_prefectures, :days ,:friends => [:hobbies, :characters, :specialities],:leader => [:profile => [:images, :hobbies, :characters, :specialities]]])

  def save_group(params)
    [:group_images, :days, :mst_prefectures].each do |association|
      ids = (association.to_s.singularize + '_ids').to_sym
      if params[:group] && params[:group][ids]
        params[association] = params[:group][ids] 
        params[:group].delete(ids)
        params[association].delete('')
      end
    end
    self.class.transaction do
      if self.persisted?
        self.update_attributes!(params[:group])
      else
        self.save!
      end
      [:group_images, :days, :mst_prefectures].each{|association| update_associations(association, params)}
    end
  end

  def update_group_by_admin(params)
    [:group_images, :days, :mst_prefectures].each do |association|
      ids = (association.to_s.singularize + '_ids').to_sym
      if params[:group] && params[:group][ids]
        params[association] = params[:group][ids] 
        params[:group].delete(ids)
        params[association].delete('')
      end
    end
    self.class.transaction do
      if self.persisted?
        self.update_attributes!(params[:group])
      else
        self.save!
      end
      [:group_images, :days, :mst_prefectures].each{|association| update_associations(association, params)}
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
    json['days'] = self.days.as_json
    json['leader'] = self.leader.profile.as_json
    json['friends'] = self.friends.as_json
    json['group_images'] = self.group_images.as_json
    json['mst_prefectures'] = self.mst_prefectures.as_json
    json
  end

  def self.member_params_exists?(params)
    [:member_status, :max_height, :min_height, :income, :blood_type, :blood_type, :jobs, :proportions, :roommates, 
      :smokings, :sociabilities, :school, :hobbies, :specialities, :characters].each do |key|
        if params.has_key?(key)
          return true
        end
    end
    false
  end
end
