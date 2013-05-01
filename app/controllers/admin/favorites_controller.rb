class Admin::FavoritesController < AdminController

  def index
    @user = User.find(params[:user_id])
    @users = @user.favorite_users.page(params[:page])
  end

  def destroy
    @favorite = Favorite.find_by_user_id_and_target_id(params[:user_id], params[:id])
    user = @favorite.user
    @favorite.destroy
    redirect_to  admin_user_favorites_url(user), :notice => "Successfully destroyed favorite."
  end
end
