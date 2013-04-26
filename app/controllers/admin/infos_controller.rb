class Admin::InfosController < AdminController
  layout "info"
  before_filter :load_user

  def index
    if @user.present?
      @infos = @user.received_infos.page(params[:page])
    else
      @infos = Info.page(params[:page])
    end
  end

  def show
    @info = Info.find(params[:id])
  end

  def new
    @info = Info.new(target_id: (@user.present? ? @user.id : -1))
  end

  def create
    @info = Info.new(params[:info])

    respond_to do |format|
      if @info.save
        if @user.present?
          format.html { redirect_to admin_user_info_path(@user, @info), notice: 'Info was successfully created.' }
        else
          format.html { redirect_to [:admin, @info], notice: 'Info was successfully created.' }
        end
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
        if @user.present?
          format.html { redirect_to admin_user_info_path(@user, @info), notice: 'Info was successfully created.' }
        else
          format.html { redirect_to [:admin, @info] }
        end
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @info = Info.find(params[:id])
    @info.destroy
    if @user.present?
      redirect_to admin_user_infos_path(@user), :notice => "Successfully destroyed info."
    else
      redirect_to admin_infos_url, :notice => "Successfully destroyed info."
    end
  end

  private 
  def load_user
    @user = User.find(params[:user_id]) if params[:user_id]
  end
end
