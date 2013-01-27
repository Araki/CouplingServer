# coding:utf-8
class Api::User::UploadController < Api::User::BaseController
  IMAGE_DATA_HASH = Pref::AWS::BUCKET_PATH[:image]

  def uploader hash
    S3IndirectUploader.new(hash[:path] + File::SEPARATOR + Time.now.strftime("%Y%m%d"), hash[:extension])
  end
  private :uploader

  def image_url
    entities = {
      url: uploader(IMAGE_DATA_HASH).url(upload_key)
    }
    render_ok(entities)
  end

  def image_parameter
    presinged_post = uploader(IMAGE_DATA_HASH).publish_url(upload_key)
    entities = {
      url: presinged_post.url.to_s,
      fields: presinged_post.fields
    }
    render_ok(entities)
  end

  private
  def upload_key
    type = params[:type] || "main"
    order = params[:order] || 0

    images = @user.images.order("order_number").find_all_by_type(model_type(type))
    if images.present?
      image = images[order.to_i]
      if image
        index = image.order_number
      else
        index = images.last.order_number + 1
        create_image(type, index)
      end
    elsif
      index = 0
      create_image(type, index)
    end

    "#{type.downcase}_#{@user.id}_#{index}"
  end

  def model_type(type)
    "#{type.capitalize}Image"
  end

  def create_image(type, index)
    image = Image.new
    image.user_id = @user.id
    image.type = model_type(type)
    image.order_number = index;
    image.save!
  end

end
