# coding:utf-8
class Api::User::UploadController < Api::User::BaseController
  IMAGE_DATA_HASH = Pref::AWS::BUCKET_PATH[:image]

  def uploader hash
    S3IndirectUploader.new(hash[:path] + File::SEPARATOR + Time.now.strftime("%Y%m%d"), hash[:extension])
  end
  private :uploader

  def image_url
    entities = {
      url: uploader(IMAGE_DATA_HASH).url(@user.id)
    }
    render_ok(entities)
  end

  def image_parameter
    presinged_post = uploader(IMAGE_DATA_HASH).publish_url(@user.id)
    entities = {
      url: presinged_post.url.to_s,
      fields: presinged_post.fields
    }
    render_ok(entities)
  end
end
