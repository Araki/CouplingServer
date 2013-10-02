# coding:utf-8
class Api::User::UsersController < Api::BaseController
  
  def list
    gender = @user.gender == 0 ? 1 : 0
    cond_param = { 
      gender: gender,
      prefecture: params[:prefecture],
      age: params[:age],
      income: params[:income]
    }
    cond = User.where_cond(cond_param)
    users = Kaminari.paginate_array(cond).page(params[:page]).per(params[:per])
    render_users_list(users)
  end

  def show
    user = User.find_by_id(params[:id])
    render_not_found and return if user.nil?
    
    render_ok(:user => user.as_json(:only => [:id]))
  end
end
