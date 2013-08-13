# -*- coding: utf-8 -*-
class Image < ActiveRecord::Base
  attr_accessible :member_id, :is_main

  belongs_to :member

  IMAGE_DATA_HASH = Pref::AWS::BUCKET_PATH[:image]

  def self.main_images 
    self.find(:all, :conditions => {is_main: true}, :order => 'member_id desc')
  end

  def self.create_member_iamge(member) 
    self.create!({
      member_id: member.id,
      is_main: member.main_image.nil?
      })
  end

  def url
    uploader(IMAGE_DATA_HASH).url(self.id.to_s)
  end

  def upload_parameter
    uploader(IMAGE_DATA_HASH).presigned_post(self.id.to_s)
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
    S3IndirectUploader.new(hash[:path], hash[:extension])
  end
end
