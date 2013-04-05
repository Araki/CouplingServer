class Image < ActiveRecord::Base
  attr_accessible :user_id, :is_main, :order_number

  belongs_to :user

  IMAGE_DATA_HASH = Pref::AWS::BUCKET_PATH[:image]

  def self.main_images 
    self.find(:all, :conditions => {is_main: true}, :order => 'user_id desc')
  end

  def self.create_user_iamge(user) 
    self.create!({
      user_id: user.id,
      is_main: user.main_image.nil?,
      order_number: user.images.count + 1      
      })
  end

  def url
    uploader(IMAGE_DATA_HASH).url(self.id.to_s)
  end

  def upload_parameter
    presinged_post = uploader(IMAGE_DATA_HASH).publish_url(self.id.to_s)
    {
      url: presinged_post.url.to_s,
      fields: presinged_post.fields
    }
  end

  def destroy_entity_and_file
    #TODO S3バケットのファイルも削除すること
    self.destroy
  end

  def as_json(options = {})
      json = super(options)
      json['url'] = url
      json
  end  

  private

  def uploader(hash)
    S3IndirectUploader.new(hash[:path] + File::SEPARATOR + self.created_at.strftime("%Y%m%d"), hash[:extension])
  end
end
