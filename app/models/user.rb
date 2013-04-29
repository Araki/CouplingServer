# -*r coding: utf-8 -*-
class User < ActiveRecord::Base

  # attr_protected :access_token, :age, :email, :facebook_id, :last_verify_at, 
  #   :point, :last_login_at, :invitation_code, :status
  attr_accessible  :access_token, :device_token, :email, :facebook_id, :point, :invitation_code,
   :status, :contract_type, :as => :admin  
  
  has_one  :profile, :dependent => :destroy
  has_one  :group, :dependent => :destroy
  has_many :receipts, :dependent => :delete_all, :order => 'created_at desc'
  has_many :received_infos, :class_name => 'Info', :foreign_key => :target_id,
   :dependent => :delete_all, :order => 'created_at desc'
  
  has_many :favorites, :dependent => :delete_all, :order => 'created_at desc'
  has_many :favorite_users, :through => :favorites, :include => [:profile], :source => :target, :uniq => true

  has_many :likes, :dependent => :delete_all, :order => 'created_at desc'
  has_many :like_users, :through => :likes, :include => [:profile], :source => :target, :uniq => true

  has_many :inverse_likes, :class_name => "Like", :foreign_key => "target_id"
  has_many :inverse_like_users, :include => [:profile], :through => :inverse_likes, :source => :user

  has_many :matches, :dependent => :delete_all, :order => 'created_at desc'
  has_many :match_users, :through => :matches, :include => [:profile], :source => :target, :uniq => true

  has_many :messages, :dependent => :destroy
  has_many :received_messages, :class_name => 'Message', :foreign_key => :target_id, :dependent => :destroy

  validates :access_token, :presence => true
  validates :facebook_id, :presence => true

  scope :order_by, lambda{|field, direction|
    if field
      f = field.blank? ? 'id' : field
      d = direction == 'DESC' ? 'DESC' : 'ASC'
      order("#{f} #{d}")
    end
  }
  scope :by_keyword, lambda{|field, keyword|
    if keyword
      if ['email', 'facebook_id', 'status', 'access_token', 'email'].include?(field)
        self.where(field => keyword)
      else
        joins(:profile).where("members.#{field}" => keyword)
      end
    end
  }

  def self.create_or_find_by_access_token(access_token, device_token)
    graph = Koala::Facebook::API.new(access_token)
    fb_profile = graph.get_object("me") 

    user = self.find_by_facebook_id(fb_profile[:id].to_i)
    user = self.new if user.nil?
    user.assign_fb_attributes(fb_profile, access_token, device_token)
    user.save!
    profile = user.profile.nil? ? Profile.new : user.profile
    profile.assign_fb_attributes(user, fb_profile)
    profile.save!
    user
  end

  def infos
    Info.find(:all, :conditions => ['target_id IN (?,?)', -1, self.id] , :order => 'created_at desc')
  end

  def like?(target)
    self.likes.exists?(:target_id => target.id)
  end

  def inverse_like?(target)
    target.likes.exists?(:target_id => self.id)
  end

  def match?(target)
    self.matches.exists?(:target_id => target.id)
  end

  def over_likes_limit_per_day?
    self.likes.where('created_at > ?', Date.today).count > configatron.likes_limit_per_day - 1
  end

  # targetに対するLikeを作る
  # 既にmatchがあれば何もしない。
  # 相手からLikeされていれば、Matchに切り替える。
  # 上記以外はtargetに対するLikeを作成。
  def create_like(target)
    return {type: "match"} if self.match?(target)

    if inverse_like?(target)
      self.create_match(target)
    else
      begin
        self.like_users << target
        target.like_point += 1
        target.save!
      rescue Exception => e
        ActiveRecord::Rollback
        return {message: "internal_server_error"}
      else
        return {type: "like"}
      end          
    end
  end

  def create_match(target)
    ActiveRecord::Base.transaction do
      inverse_like = Like.find_by_user_id_and_target_id(target.id, self.id)
      inverse_like.update_attribute(:type, 'Match')
      self.match_users << target
    end
      return {type: "match"}
    rescue => e
      return {message: "internal_server_error"}    
  end

  def add_point(amount)
    if amount > 0
      begin
        self.point += amount
        self.save!
      rescue ActiveRecord::RecordInvalid => e
        self.errors.add :base, "internal_server_error"
        false
      end
    else
      self.errors.add :base, "invalid_arguments"
      false
    end
  end

  def consume_point(amount)
    if amount > 0 && amount < self.point
      begin
        self.point -= amount
        self.save!
      rescue ActiveRecord::RecordInvalid => e
        self.errors.add :base, "internal_server_error"
        false
      end
    else
      self.errors.add :base, "invalid_arguments"
      false
    end
  end

  def count_unread_messages
    Match.where('target_id = ?', self.id).collect(&:count_unread).inject{|s,i|s+=i} || 0
  end

=begin
    FacebookIDとアクセストークンを渡すとプロフィールの情報を更新する。
    TODO 最終ログインの更新
    TODO バリデーション

    Facebook response
    {
      "id"=>"123456", 
      "name"=>"First Middle Last", 
      "first_name"=>"First", 
      "middle_name"=>"Middle", 
      "last_name"=>"Last", 
      "link"=>"http://www.facebook.com/MyName", 
      "username"=>"my.name", 
      "birthday"=>"12/12/1212", 
      "hometown"=>{"id"=>"115200305133358163", "name"=>"City, State"}, "location"=>{"id"=>"1054648928202133335", "name"=>"City, State"}, 
      "bio"=>"This is my awesome Bio.", 
      "quotes"=>"I am the master of my fate; I am the captain of my soul. - William Ernest Henley\r\n\r\n"Don't go around saying the world owes you a living. The world owes you nothing. It was here first.\" - Mark Twain", 
      "work"=>[{"employer"=>{"id"=>"100751133333", "name"=>"Company1"}, "position"=>{"id"=>"105763693332790962", "name"=>"Position1"}, "start_date"=>"2010-08", "end_date"=>"2011-07"}],
      "sports"=>[{"id"=>"104019549633137", "name"=>"Sport1"}, {"id"=>"103992339636529", "name"=>"Sport2"}], 
      "favorite_teams"=>[{"id"=>"105467226133353743", "name"=>"Fav1"}, {"id"=>"19031343444432369133", "name"=>"Fav2"}, {"id"=>"98027790139333", "name"=>"Fav3"}, {"id"=>"104055132963393331", "name"=>"Fav4"}, {"id"=>"191744431437533310", "name"=>"Fav5"}], 
      "favorite_athletes"=>[{"id"=>"10836600585799922", "name"=>"Fava1"}, {"id"=>"18995689436787722", "name"=>"Fava2"}, {"id"=>"11156342219404022", "name"=>"Fava4"}, {"id"=>"11169998212279347", "name"=>"Fava5"}, {"id"=>"122326564475039", "name"=>"Fava6"}], 
      "inspirational_people"=>[{"id"=>"16383141733798", "name"=>"Fava7"}, {"id"=>"113529011990793335", "name"=>"fava8"}, {"id"=>"112032333138809855566", "name"=>"Fava9"}, {"id"=>"10810367588423324", "name"=>"Fava10"}], 
      "education"=>[{"school"=>{"id"=>"13478880321332322233663", "name"=>"School1"}, "type"=>"High School", "with"=>[{"id"=>"1401052755", "name"=>"Friend1"}]}, {"school"=>{"id"=>"11482777188037224", "name"=>"School2"}, "year"=>{"id"=>"138383069535219", "name"=>"2005"}, "type"=>"High School"}, {"school"=>{"id"=>"10604484633093514", "name"=>"School3"}, "year"=>{"id"=>"142963519060927", "name"=>"2010"}, "concentration"=>[{"id"=>"10407695629335773", "name"=>"c1"}], "type"=>"College"}, {"school"=>{"id"=>"22030497466330708", "name"=>"School4"}, "degree"=>{"id"=>"19233130157477979", "name"=>"c3"}, "year"=>{"id"=>"201638419856163", "name"=>"2011"}, "type"=>"Graduate School"}], 
      "gender"=>"male", 
      "interested_in"=>["female"], 
      "relationship_status"=>"Single", 
      "religion"=>"Religion1", 
      "political"=>"Political1", 
      "email"=>"somename@somecompany.com", 
      "timezone"=>-8, 
      "locale"=>"en_US", 
      "languages"=>[{"id"=>"10605952233759137", "name"=>"English"}, {"id"=>"10337617475934611", "name"=>"L2"}, {"id"=>"11296944428713061", "name"=>"L3"}], 
      "verified"=>true,
      "updated_time"=>"2012-02-24T04:18:05+0000"
    }
=end
  def assign_fb_attributes(fb_profile, access_token, device_token)
    params = {access_token: access_token}
      # params.picture = graph.get_picture(uid) 
    params[:device_token] = device_token unless device_token.nil?      
    params[:email] =        fb_profile[:email] 
    params[:facebook_id] =  self.facebook_id || fb_profile['id']
    params[:gender] =  fb_profile[:gender] == "male" ? 0 : 1
    params[:last_login_at] = Time.now      
    self.assign_attributes(params, :without_protection => true)
    self
  end

  def as_json(options = {})
      json = super(options)
      json['profile'] = self.profile.as_json
      json
  end  
end
