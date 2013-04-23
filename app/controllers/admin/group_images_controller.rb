class Admin::GroupImagesController < AdminController

  def index
    @group_images = GroupImage.page(params[:page])
  end

  def show
    @group_image = GroupImage.find(params[:id])
  end

  def new
    @group_image = GroupImage.new
  end

  def create
    @group_image = GroupImage.new(params[:group_image])

    respond_to do |format|
      if @group_image.save
        format.html { redirect_to [:admin, @group_image], notice: 'GroupImage was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @group_image = GroupImage.find(params[:id])
  end

  def update
    @group_image = GroupImage.find(params[:id])

    respond_to do |format|
      if @group_image.update_attributes(params[:group_image])
        format.html { redirect_to [:admin, @group_image] }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @group_image = GroupImage.find(params[:id])
    @group_image.destroy
    redirect_to admin_group_images_url, :notice => "Successfully destroyed group_image."
  end
end
