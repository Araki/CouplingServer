# -*r coding: utf-8 -*-
class User < ActiveRecord::Base

  # attr_protected :access_token, :age, :email, :facebook_id, :like_point, 
  #   :gender, :point, :last_login_at, :invitation_code, :status, :public_status
  
  has_one  :profile
  has_one  :group
  has_many :receipts, :dependent => :delete_all, :order => 'created_at desc'
  has_many :favorites, :dependent => :delete_all, :order => 'created_at desc'
  has_many :likes, :dependent => :delete_all, :order => 'created_at desc'
  has_many :likeds, :class_name => "Like", :foreign_key => "target_id", :dependent => :delete_all, :order => 'created_at desc'
  has_many :matches, :dependent => :delete_all, :order => 'created_at desc'

  has_many :favorite_users, :through => :favorites, :source => :target_user, :include => [:profile], :uniq => true
  has_many :like_users, :through => :likes, :source => :target_user, :include => [:profile], :uniq => true
  has_many :liked_users, :through => :likeds, :source => :user, :include => [:profile], :uniq => true
  has_many :match_users, :through => :matches, :source => :target_user, :include => [:profile], :uniq => true

  validates :access_token, :presence => true
  validates :facebook_id, :presence => true

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
    user.profile = profile
    user
  end

  def self.where_cond(params)
    cond = self.where(gender: params[:gender])
    if params[:prefecture].present?
      ids = Profile.where(prefecture: params[:prefecture]).map(&:user_id)
      cond = cond.where(["id in (?)", ids])
    end
    if params[:age].present?
      ids = Profile.where(age: params[:age]).map(&:user_id)
      cond = cond.where(["id in (?)", ids])
    end
    if params[:income].present?
      ids = Profile.where(sincome: params[:income]).map(&:user_id)
      cond = cond.where(["id in (?)", ids])
    end
    cond
  end

  def infos
    Info.find(:all, :conditions => ['target_id IN (?,?)', -1, self.id] , :order => 'created_at desc')
  end

  def like?(target)
    Like.find_by_user_id_and_target_id(self.id, target.id).present?
  end

  def liked?(target)
    Like.find_by_user_id_and_target_id(target.id, self.id).present?
  end

  def match?(target)
    Match.find_by_user_id_and_target_id(self.id, target.id).present?
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

    if liked?(target)
      self.create_match(target)
    else
      begin
        self.like_users << target
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
      target.like_users.delete self
      self.match_users << target
      target.match_users << self
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

  def add_like_point(amount)
    if amount > 0
      begin
        self.like_point += amount
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

  def consume_like_point(amount)
    if amount > 0 && amount < self.like_point
      begin
        self.like_point -= amount
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
