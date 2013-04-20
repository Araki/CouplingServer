# coding:utf-8
class Api::FavoritesController < Api::BaseController
  
  def list
    favorite_profiles = Kaminari.paginate_array(@user.favorite_profiles).page(params[:page]).per(params[:per])
    render_profiles_list(favorite_profiles)
  end

  def create
    profile = Profile.find_by_id(params[:profile_id])
    render_not_found and return if profile.nil?

    begin
      @user.favorite_profiles << profile
    rescue Exception => e
      ActiveRecord::Rollback
      render_ng("internal_server_error") and return
    else
      render_ok
    end
  end

  def destroy
    profile = Profile.find_by_id(params[:profile_id])
    @user.favorite_profiles.delete(profile) if profile.present?
    render_ok
  end
end
