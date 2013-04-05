# -*r coding: utf-8 -*-

#相手が既にLikeしていた場合に作成される。
#自分から相手と相手から自分への2つのmatchが同時に作成される。

class Match < ActiveRecord::Base
  # attr_accessible :user_id, :target_id, :messages_count, :can_open_profile
  belongs_to :user, :dependent => :destroy
  belongs_to :target_user, :class_name => "User", :foreign_key => "target_id", :dependent => :destroy
  has_many :messages, :dependent => :delete_all

  #targetからuserへの対となるmatchを返す。
  def pair
    Match.find_by_id_and_target_id(self.target_id, self.user_id)
  end

  def talks(since_id)
    since_id = since_id || 0
    Message.includes(:match).where("talk_key = ? AND id > ?", self.talk_key, since_id).order("created_at")
  end

  #messageの作成
  def create_message(params)
    params[:talk_key] = self.talk_key
    message = Message.new(params)
    ActiveRecord::Base.transaction do
      self.messages << message
      can_open_profile?()
    end
      return true
    rescue => e
      return false
  end

  def talk_key
    self.user_id < self.target_id ? "#{self.user_id}_#{self.target_id}" : "#{self.target_id}_#{self.user_id}"
  end

private

  #can_open_profileがfalseならば自分と相手のメッセージ数を数えてどちらも3以上ならプロフィールを公開可能にする
  #自分のmessageが2以上で相手からのものが3以上だったら
  def can_open_profile?
    unless self.can_open_profile
      if self.messages_count > 1 && self.pair.messages_count > 2
        self.update_attribute(:can_open_profile, true)
        self.pair.update_attribute(:can_open_profile, true)
      end      
    end
  end
end
