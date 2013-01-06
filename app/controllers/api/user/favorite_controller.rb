# coding:utf-8
class Api::User::FavoriteController < Api::User::BaseController
  def show
    favorites = Favorite.find_by_user_id(@user.id)
    if favorites.present?
      render_ok(:favorite => favorites.map(&:to_hash))
    else
      render_ok(:favorite => [])
    end
  end

  def add
    begin
      Favorite.create!({
        user_id: @user.id,
        target_id: params[:target_id],
      });
    rescue Exception => e
      ActiveRecord::Rollback
      render_ng("internal_server_error") and return
    else
      render_ok
    end
  end
end
