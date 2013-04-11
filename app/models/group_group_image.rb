# coding:utf-8
class GroupGroupImage < ActiveRecord::Base
  belongs_to :group,  :dependent => :destroy
  belongs_to :group_image, :dependent => :destroy
end
