class Admin::FriendsController < AdminController

  def index
    @friends = Friend.page(params[:page])
  end

  def show
    @friend = Friend.find(params[:id])
  end

  def edit
    @friend = Friend.find(params[:id])
  end

  def update
    @friend = Friend.find(params[:id])

    respond_to do |format|
      if @friend.update_profile_by_admin(params)
        format.html { redirect_to [:admin, @friend.group.leader] }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @friend = Friend.find(params[:id])
    @leader = @friend.group.leader

    @friend.destroy
    redirect_to [:admin, @friend.group.leader], :notice => "Successfully destroyed friend."
  end
end
