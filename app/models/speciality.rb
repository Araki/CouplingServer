# coding:utf-8
class Speciality < ActiveRecord::Base
  attr_accessible :name
  has_many :user_specialities
  has_many :users, :through => :user_specialities
end
