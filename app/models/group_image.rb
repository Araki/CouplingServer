# coding:utf-8
class GroupImage < ActiveRecord::Base
  attr_accessible :name
  has_many :group_group_images
  has_many :group, :through => :group_group_images
end
