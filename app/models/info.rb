# coding:utf-8
class Info < ActiveRecord::Base
  attr_accessible :body, :target_id

  default_scope order('created_at DESC')

  validates :body, 
    :presence => true,
    :length => { :minimum => 1, :maximum => 500 }

  validates :target_id,
    :presence => true,  
    :numericality => { :only_integer => true, :greater_than_or_equal_to => -1, :less_than_or_equal_to => 2147483647,
                        :allow_blank => true }
end
