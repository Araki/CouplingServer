# coding:utf-8
class Profile < Member
  attr_accessible :birthday_on, :user_id
  
  belongs_to :user
  belongs_to :group

  has_many :favorites, :dependent => :delete_all, :order => 'created_at desc'
  has_many :likes, :dependent => :delete_all, :order => 'created_at desc'
  has_many :matches, :dependent => :delete_all, :order => 'created_at desc'
  has_many :favorite_from_users, :through => :favorites, :source => :user, :uniq => true
  has_many :like_from_users, :through => :likes, :source => :user, :uniq => true
  has_many :match_from_users, :through => :matches, :source => :user, :uniq => true

  def assign_fb_attributes(user, fb_profile)
    params = {user_id: user.id}
    params[:age] =  get_age(fb_profile)  
    params[:gender] =  fb_profile[:gender] == "male" ? 0 : 1
    params[:nickname] =  self.nickname || get_initial(fb_profile)
    params[:birthday_on] =   Date.strptime(fb_profile[:birthday], '%m/%d/%Y')
    self.assign_attributes(params, :without_protection => true)
    self
  end

  def as_json(options = {})
      json = super(options)
      # json['images'] = self.images.as_json
      json
  end  

  private

  def get_initial(fb_profile)
    "#{fb_profile[:first_name][0, 1].capitalize}.#{fb_profile[:last_name][0, 1].capitalize}"
  end

  #age 誕生日を考慮していないので実際には不正確
  def get_age(fb_profile)
    Time.now.utc.to_date.year - Date.strptime(fb_profile[:birthday], '%m/%d/%Y').year
  end  
end
