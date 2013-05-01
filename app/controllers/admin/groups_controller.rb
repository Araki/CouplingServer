class Admin::GroupsController < AdminController
  layout "group"

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
      if @group.update_group_by_admin(params)
        format.html { redirect_to [:admin, @group.leader] }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @group = Group.find(params[:id])
    leader = @group.leader
    @group.destroy
    redirect_to  [:admin, leader], :notice => "Successfully destroyed group."
  end
end
