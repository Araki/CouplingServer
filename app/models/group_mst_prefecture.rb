# coding:utf-8
class GroupMstPrefecture < ActiveRecord::Base
  belongs_to :group
  belongs_to :mst_prefecture
end
