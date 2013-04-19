# coding:utf-8
require 'model_helper'

class Group < ActiveRecord::Base
  include ModelHelper
  attr_accessible :gender, :max_age, :min_age, :head_count,:relationship, :request, :opening_hour, :target_age_range, :area, :user_id, :status

  belongs_to  :leader, :class_name => 'User', :foreign_key => :user_id
  has_many :friends
  has_many :members

  has_many :group_group_images
  has_many :group_images, :through => :group_group_images
  has_many :group_days
  has_many :days, :through => :group_days
  has_many :group_mst_prefectures
  has_many :mst_prefectures, :through => :group_mst_prefectures

  validates :max_age, :inclusion => { :in => 0..100 }, :presence => true
  validates :min_age, :inclusion => { :in => 0..100 }, :presence => true
  validates :head_count, :inclusion => { :in => 0..10 }, :presence => true

  # validates :opening_hour, :allow_nil => true
  validates :relationship, :length => { :maximum => 50 }, :allow_nil => true
  validates :request, :length => { :maximum => 500 }, :allow_nil => true
  validates :target_age_range, :inclusion => { :in => 0..10 }, :allow_nil => true
  validates :area, :length => { :maximum => 50 }, :allow_nil => true

  def save_group(params)
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
end
