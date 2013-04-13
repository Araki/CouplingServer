# coding:utf-8
class Item < ActiveRecord::Base
  attr_accessible :title, :pid, :receipts_count, :point

end
