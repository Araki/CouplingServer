# coding:utf-8
class Api::User::UserController < Api::User::BaseController
  def list
    limit = params[:limit] ? params[:limit] : 10
    offset = params[:offset] ? params[:offset] : 0
    gender = @user.gender == 0 ? 1 : 0
    users = User.where(gender: gender).offset(offset).limit(limit).map(&:to_hash)
    render_ok(user: users)
  end

end
