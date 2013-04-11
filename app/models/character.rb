# coding:utf-8
class Character < ActiveRecord::Base
  attr_accessible :name
  has_many :user_characters
  has_many :users, :through => :user_characters
end
