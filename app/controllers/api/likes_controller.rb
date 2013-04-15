# coding:utf-8
class Api::LikesController < Api::BaseController
  
  def list
    if params[:type] == 'liked'
      profiles = Kaminari.paginate_array(@user.liked_profiles).page(params[:page]).per(params[:per])
    else
      profiles = Kaminari.paginate_array(@user.like_profiles).page(params[:page]).per(params[:per])
    end

    render_profiles_list(profiles)
  end

  def create
    if @user.profile.gender == 0
      render_ng("over_limit") and return if @user.over_likes_limit_per_day?
    end

    profile = Profile.find_by_id(params[:profile_id])
    render_not_found and return unless profile

    result = @user.create_like(profile)
    result.has_key?(:type) ? render_ok(result) : render_ng("internal_server_error")
  end
end
