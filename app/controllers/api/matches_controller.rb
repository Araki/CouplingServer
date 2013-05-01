# coding:utf-8
class Api::MatchesController < Api::BaseController
  
  def list
    users = Kaminari.paginate_array(@user.match_users).page(params[:page]).per(params[:per])
    render_users_to_profiles_list(users)
  end
end
