# coding:utf-8
class Api::ImagesController < Api::BaseController

  def list
    main_images = Kaminari.paginate_array(Image.main_images).page(params[:page]).per(params[:per])
    render_pagenate_data(:images, main_images, {})
  end

  def create
    raise StandardError.new("Limit Over") if @user.profile.images.count > configatron.imagess_limit - 1

    image = Image.create_member_iamge(@user.profile) 

    render_ok(image.upload_parameter)
  end

  def set_main
    image = Image.find(params[:id])
    raise PermissionDenied unless @user.profile.id == image.member.id

    @user.profile.set_main_image(image)
    render_ok
  end

  def destroy
    image = Image.find(params[:id])
    raise PermissionDenied unless @user.profile.id == image.member.id

    image.destroy_entity_and_file
    render_ok
  end
end
