# coding:utf-8
class Api::User::AccountController < Api::BaseController

  def show_profile
    render_ok(:profile => @user.profile.as_json)
  end

  def update_profile
    @user.profile.save_profile(params)
    render_ok(:profile => @user.profile.as_json)
  end

  def destroy
    @user.destroy
    render_ok
  end
end
