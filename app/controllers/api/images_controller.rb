# coding:utf-8
class Api::ImagesController < Api::BaseController

  def list
    main_images = Kaminari.paginate_array(Image.main_images).page(params[:page]).per(params[:per])
    render_pagenate_data(:images, main_images, {})
  end

  def create
    render_ng("over_limit") and return if @user.profile.images.count > 4

    begin
      image = Image.create_member_iamge(@user.profile) 
    rescue Exception => e
      ActiveRecord::Rollback
      render_ng("internal_server_error")
    else
      render_ok(image.upload_parameter)
    end    
  end

  def set_main
    image = Image.find_by_id(params[:id])
    render_not_found and return unless image
    render_ng("permission_denied") and return unless @user.profile.id == image.member.id

    if @user.profile.set_main_image(image)
      render_ok
    else
      render_ng("internal_server_error")
    end
  end

  def destroy
    image = Image.find_by_id(params[:id])
    render_ng("permission_denied") and return unless @user.profile.id == image.member.id

    image.destroy_entity_and_file
    render_ok
  end
end
