class Admin::GroupsController < AdminController

  def index
    @groups = Group.page(params[:page])
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.save_group(params)
        format.html { redirect_to [:admin, @group.leader] }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to admin_groups_url, :notice => "Successfully destroyed group."
  end
end
