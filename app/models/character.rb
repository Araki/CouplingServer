# coding:utf-8
class Character < ActiveRecord::Base
  attr_accessible :name
  has_many :member_characters
  has_many :members, :through => :member_characters
end
