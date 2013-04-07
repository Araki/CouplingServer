# coding:utf-8
class Api::User::AccountController < Api::BaseController

  def show_profile
    render_ok(:user => @user.as_json(:except => [:email, :facebook_id, :access_token, :point]))
  end

  def update_profile
    begin
      @user.update_attributes!(params[:user])
    rescue Exception => e
      render_ng(e.message)
    else
      render_ok(:user => @user.as_json(:except => [:email, :facebook_id, :access_token, :point]))
    end
  end

  def destroy
    @user.destroy
    render_ok
  end
end
