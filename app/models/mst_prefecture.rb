class MstPrefecture < ActiveRecord::Base
  attr_accessible :name
  has_many :group, :through => :group_mst_prefectures
end
