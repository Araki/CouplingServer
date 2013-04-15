# coding:utf-8
class Api::ProfilesController < Api::BaseController
  
  def list
    gender = @user.profile.gender == 0 ? 1 : 0
    profiles = Kaminari.paginate_array(Profile.where(gender: gender)).page(params[:page]).per(params[:per])
    render_profiles_list(profiles)
  end

  def show
    profile = Profile.find_by_id(params[:id])
    render_not_found and return if profile.nil?
    
    render_ok(:profile => profile.as_json)
  end
end
