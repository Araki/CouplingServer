# coding:utf-8
class Item < ActiveRecord::Base
  attr_accessible :title, :pid, :receipts_count, :point
  has_many :receipts, :dependent => :destroy

  validates :title, 
    :presence => true,
    :length => { :minimum => 1, :maximum => 50 }
  validates :pid, 
    :presence => true,
    :length => { :minimum => 1, :maximum => 100 }
  validates :point, 
    :presence => true,
    :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 10000000}
end
