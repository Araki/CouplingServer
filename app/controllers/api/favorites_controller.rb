# coding:utf-8
class Api::FavoritesController < Api::BaseController
  
  def list
    favorite_users = Kaminari.paginate_array(@user.favorite_users).page(params[:page]).per(params[:per])
    render_users_to_profiles_list(favorite_users)
  end

  def create
    target = User.find(params[:target_id])

    @user.favorite_users << target
    render_ok
  end

  def destroy
    target = User.find(params[:target_id])
    @user.favorite_users.delete(target)
    render_ok
  end
end
