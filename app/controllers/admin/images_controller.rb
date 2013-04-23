class Admin::ImagesController < AdminController

  def index
    @images = Image.page(params[:page])
  end

  def show
    @image = Image.find(params[:id])
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    redirect_to admin_images_url, :notice => "Successfully destroyed image."
  end
end
