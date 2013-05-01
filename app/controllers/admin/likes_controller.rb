class Admin::LikesController < AdminController

  def index
    @user = User.find(params[:user_id])
    @users = @user.like_users.page(params[:page])
  end

  def destroy
    @like = Like.find_by_user_id_and_target_id(params[:user_id], params[:id])
    user = @like.user
    @like.destroy
    redirect_to admin_user_likes_url(user), :notice => "Successfully destroyed like."
  end
end
