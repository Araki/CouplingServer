# -*r coding: utf-8 -*-

#相手が既にLikeしていた場合に作成される。
#自分から相手と相手から自分への2つのmatchが同時に作成される。

class Match < Relation
  attr_accessible :last_read_at, :can_open_profile
  has_many :messages, :dependent => :destroy

  def count_unread
    self.messages.where("messages.created_at > ?", self.last_read_at).count
  end
end