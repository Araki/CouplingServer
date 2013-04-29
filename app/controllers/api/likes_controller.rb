# coding:utf-8
class Api::LikesController < Api::BaseController
  
  def list
    if params[:type] == 'inverse'
      users = @user.inverse_like_users.page(params[:page]).per(params[:per])
      @user.update_attribute(:check_like_at, Time.now)
    else
      users = @user.like_users.page(params[:page]).per(params[:per])
    end

    render_users_to_profiles_list(users)
  end

  def create
    render_ng("over_limit") and return if @user.over_likes_limit_per_day?

    target = User.find_by_id(params[:target_id])
    render_not_found and return unless target

    result = @user.create_like(target)
    result.has_key?(:type) ? render_ok(result) : render_ng("internal_server_error")
  end
end
