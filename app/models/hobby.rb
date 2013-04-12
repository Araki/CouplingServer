# coding:utf-8
class Hobby < ActiveRecord::Base
  attr_accessible :name
  has_many :member_hobbies
  has_many :members, :through => :member_hobbies
end
