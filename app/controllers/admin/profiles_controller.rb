class Admin::ProfilesController < AdminController
  layout "profile"

  def index
    @profiles = Profile.page(params[:page])
  end

  def show
    @profile = Profile.find(params[:id])
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])

    respond_to do |format|
      if @profile.update_profile_by_admin(params)
        format.html { redirect_to [:admin, @profile.user] }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @profile = Profile.find(params[:id])
    user = @profile.user
    @profile.destroy
    redirect_to [:admin, user], :notice => "Successfully destroyed profile."
  end
end