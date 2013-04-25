# coding:utf-8
class GroupGroupImage < ActiveRecord::Base
  belongs_to :group
  belongs_to :group_image
end
