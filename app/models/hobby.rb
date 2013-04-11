# coding:utf-8
class Hobby < ActiveRecord::Base
  attr_accessible :name
  has_many :user_hobbies
  has_many :users, :through => :user_hobbies
end
