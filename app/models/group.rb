# coding:utf-8
class Group < ActiveRecord::Base
  attr_accessible :max_age, :min_age, :head_count,:relationship, :request, :opening_hour, :target_age_range, :area, :user_id, :status

  has_one  :leader, :class_name => 'User'
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
end
