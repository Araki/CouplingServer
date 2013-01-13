# coding:utf-8
class Api::User::ProfileController < Api::User::BaseController
  def show
    if user_id = params[:user_id]
      target_user = User.find_by_id(user_id)
    else
      target_user = @user
    end
    render_not_found and return unless target_user
    render_ok(target_user.to_hash)
  end

  def edit
    render_ok(@user.to_hash)
  end

end
