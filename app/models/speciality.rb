# coding:utf-8
class Speciality < ActiveRecord::Base
  attr_accessible :name
  has_many :member_specialities
  has_many :members, :through => :member_specialities
end
