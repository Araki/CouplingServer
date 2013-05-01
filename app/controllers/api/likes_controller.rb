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
    raise StandardError.new("Limit Over") if @user.over_likes_limit_per_day?

    target = User.find(params[:target_id])

    result = @user.create_like(target)
    render_ok(result)
  end
end
