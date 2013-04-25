# coding:utf-8
class GroupDay < ActiveRecord::Base
  belongs_to :group
  belongs_to :day
end
