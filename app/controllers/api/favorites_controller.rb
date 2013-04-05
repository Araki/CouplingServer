# coding:utf-8
class Api::FavoritesController < Api::BaseController
  
  def list
    favorite_users = Kaminari.paginate_array(@user.favorite_users).page(params[:page]).per(params[:per])
    render_users_list(favorite_users)
  end

  def create
    target_user = User.find_by_id(params[:target_id])
    render_not_found and return if target_user.nil?

    begin
      @user.favorite_users << target_user
    rescue Exception => e
      ActiveRecord::Rollback
      render_ng("internal_server_error") and return
    else
      render_ok
    end
  end

  def destroy
    target_user = User.find_by_id(params[:target_id])
    @user.favorite_users.delete(target_user) if target_user.present?
    render_ok
  end
end
