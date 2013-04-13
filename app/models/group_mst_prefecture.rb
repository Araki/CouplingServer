# coding:utf-8
class GroupMstPrefecture < ActiveRecord::Base
  belongs_to :group,  :dependent => :destroy
  belongs_to :mst_prefecture, :dependent => :destroy
end
