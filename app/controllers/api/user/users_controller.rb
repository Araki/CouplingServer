# coding:utf-8
class Api::User::UsersController < Api::BaseController
  
  def list
    gender = @user.gender == 0 ? 1 : 0
    users = Kaminari.paginate_array(User.where(gender: gender)).page(params[:page]).per(params[:per])
    render_users_list(users)
  end

  def show
    user = User.find_by_id(params[:id])
    render_not_found and return if user.nil?
    
    render_ok(:user => user.as_json(:except => [:email, :facebook_id, :access_token, :point]))
  end
end
