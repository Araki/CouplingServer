class Admin::InfosController < AdminController

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @infos = @user.received_infos.page(params[:page])
    else
      @infos = Info.page(params[:page])
    end
  end

  def show
    @info = Info.find(params[:id])
  end

  def new
    @info = Info.new
  end

  def create
    @info = Info.new(params[:info])

    respond_to do |format|
      if @info.save
        format.html { redirect_to [:admin, @info], notice: 'Info was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def edit
    @info = Info.find(params[:id])
  end

  def update
    @info = Info.find(params[:id])

    respond_to do |format|
      if @info.update_attributes(params[:info])
        format.html { redirect_to [:admin, @info] }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @info = Info.find(params[:id])
    @info.destroy
    redirect_to admin_infos_url, :notice => "Successfully destroyed info."
  end
end
