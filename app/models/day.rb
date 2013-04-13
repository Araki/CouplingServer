# coding:utf-8
class Day < ActiveRecord::Base
  attr_accessible :name
  has_many :group_days
  has_many :users, :through => :group_days
end
