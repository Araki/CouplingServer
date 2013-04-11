# -*r coding: utf-8 -*-
class User < ActiveRecord::Base

  # attr_protected :access_token, :age, :email, :facebook_id, :like_point, 
  #   :gender, :point, :last_login_at, :invitation_code

  attr_accessible :alcohol, :birthplace, :blood_type, :character, :contract_type, :prefecture,
    :dislike, :height, :holiday, :income, :industry, :introduction, :job, 
    :job_description, :marital_history, :marriage_time, :nickname, :status, 
    :proportion, :public_status, :roommate, :school, :smoking, :sociability, :workplace

  has_one  :main_image, :class_name => "Image", :conditions => { :is_main => true }
  has_many :images, :dependent => :delete_all
  has_many :receipts, :dependent => :delete_all, :order => 'created_at desc'
  has_many :favorites, :dependent => :delete_all, :order => 'created_at desc'
  has_many :likes, :dependent => :delete_all, :order => 'created_at desc'
  has_many :likeds, :class_name => "Like", :foreign_key => "target_id", :dependent => :delete_all, :order => 'created_at desc'
  has_many :matches, :dependent => :delete_all, :order => 'created_at desc'

  has_many :favorite_users, :through => :favorites, :source => :target_user, :include => [:images], :uniq => true
  has_many :like_users, :through => :likes, :source => :target_user, :include => [:images], :uniq => true
  has_many :liked_users, :through => :likeds, :source => :user, :include => [:images], :uniq => true
  has_many :match_users, :through => :matches, :source => :target_user, :include => [:images], :uniq => true

  has_many :user_hobbies
  has_many :hobbies, :through => :user_hobbies
  has_many :user_specialities
  has_many :specialities, :through => :user_specialities
  has_many :user_characters
  has_many :characters, :through => :user_characters

  validates :access_token, :presence => true
  validates :age, :presence => true
  validates :email, :presence => true
  validates :facebook_id, :presence => true
  validates :gender, 
    :presence => true,
    :inclusion => { :in => [0, 1] }
  validates :nickname, 
    :presence => true,
    :length => { :minimum => 1, :maximum => 50 }

  validates :alcohol, :inclusion => { :in => 0..3 }, :allow_nil => true
  validates :birthplace, :inclusion => { :in => 1..47 }, :allow_nil => true
  validates :prefecture, :inclusion => { :in => 1..47 }, :allow_nil => true
  # validates :character, :inclusion => { :in => 0..46 }, :allow_nil => true
  validates :holiday, :inclusion => { :in => 0..3 }, :allow_nil => true
  validates :income, :inclusion => { :in => 0..7 }, :allow_nil => true
  validates :introduction, :length => { :minimum => 70, :maximum => 500 }, :allow_nil => true
  validates :height, :inclusion => { :in => 130..210 }, :allow_nil => true
  validates :proportion, :inclusion => { :in => 0..7 }, :allow_nil => true
  # validates :roommate, :inclusion => { :in => 0..3 }, :allow_nil => true
  validates :smoking, :inclusion => { :in => 0..2 }, :allow_nil => true


  def self.create_or_find_by_access_token(access_token)
    user = self.find_by_access_token(access_token)
    user = self.new if user.nil?
    user.assign_fb_attributes(access_token)
    user.save!
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

  def set_main_image(image)
    ActiveRecord::Base.transaction do
      self.main_image.update_attribute(:is_main, false ) if self.main_image.present?
      image.update_attribute(:is_main, true )
    end
      return true
    rescue => e
      return false
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
  def assign_fb_attributes(access_token)
    graph = Koala::Facebook::API.new(access_token)
    profile = graph.get_object("me") 
    params = {access_token: access_token}
      # params.picture = graph.get_picture(uid) 
    params[:email] =     profile[:email] 
    params[:nickname]    = self.nickname || get_initial(profile)
    params[:facebook_id] = self.facebook_id || profile[:id]
    params[:gender] =    profile[:gender] == "male" ? 0 : 1
    params[:age] =       get_age(profile)      
    params[:last_login_at] = Time.now      

    self.assign_attributes(params, :without_protection => true)
    self
  end

  def as_json(options = {})
      json = super(options)
      json['images'] = self.images.as_json
      json
  end  


  private

  def get_initial(profile)
    "#{profile[:first_name][0, 1].capitalize}.#{profile[:last_name][0, 1].capitalize}"
  end

  #age 誕生日を考慮していないので実際には不正確
  def get_age(profile)
    Time.now.utc.to_date.year - Date.strptime(profile[:birthday], '%m/%d/%Y').year
  end  
end
