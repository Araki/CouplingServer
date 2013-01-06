# coding:utf-8
class Api::User::LikeController < Api::User::BaseController
  def show
    likes = Like.find_by_user_id(@user.id)
    if likes.present?
      render_ok(:like => likes.map(&:to_hash))
    else
      render_ok(:like => [])
    end
  end

  def add
    begin
      Like.create!({
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
