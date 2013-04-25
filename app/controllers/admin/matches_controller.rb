class Admin::MatchesController < AdminController

  def index
    @user = User.find(params[:user_id])
    @profiles = @user.match_profiles.page(params[:page])
  end

  def destroy
    @match = Match.find_by_user_id_and_profile_id(params[:user_id], params[:id])
    user = @match.user
    @match.destroy
    redirect_to admin_user_matches_url(user), :notice => "Successfully destroyed match."
  end
end
