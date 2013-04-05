# coding:utf-8
class Api::LikesController < Api::BaseController
  
  def list
    if params[:type] == 'liked'
      users = Kaminari.paginate_array(@user.liked_users).page(params[:page]).per(params[:per])
    else
      users = Kaminari.paginate_array(@user.like_users).page(params[:page]).per(params[:per])
    end

    render_users_list(users)
  end

  def create
    target_user = User.find_by_id(params[:target_id])
    render_not_found and return unless target_user

    result = @user.create_like(target_user)
    result.has_key?(:type) ? render_ok(result) : render_ng("internal_server_error")
  end
end
