# coding:utf-8
class Api::MatchesController < Api::BaseController
  
  def list
    profiles = Kaminari.paginate_array(@user.match_profiles).page(params[:page]).per(params[:per])
    render_profiles_list(profiles)
  end
end
