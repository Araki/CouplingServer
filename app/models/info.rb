# coding:utf-8
class Info < ActiveRecord::Base
  attr_accessible :body, :target_id

  belongs_to :target, :class_name => "User", :foreign_key => "target_id"
 
  default_scope order('created_at DESC')

  scope :by_target_user, lambda{|user| where(target_id: [-1, user.id]) unless user.nil?}
  scope :after_created_at, lambda{|check_at| where("created_at > ?", check_at) unless check_at.nil?}

  validates :body, 
    :presence => true,
    :length => { :minimum => 1, :maximum => 500 }

  validates :target_id,
    :presence => true,  
    :numericality => { :only_integer => true, :greater_than_or_equal_to => -1, :less_than_or_equal_to => 2147483647,
                        :allow_blank => true }
end
