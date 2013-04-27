class Admin::UsersController < AdminController
  layout "user"

  def index
    @users = User.by_keyword(params[:field], params[:keyword]).
      order_by(params[:field], params[:direction]).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.assign_attributes(params[:user], :as => :admin)

    respond_to do |format|
      if @user.save
        format.html { redirect_to [:admin, @user] }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url, :notice => "Successfully destroyed user."
  end
end
