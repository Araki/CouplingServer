# coding:utf-8
class GroupDay < ActiveRecord::Base
  belongs_to :group,  :dependent => :destroy
  belongs_to :day, :dependent => :destroy
end
