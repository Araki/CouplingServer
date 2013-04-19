# coding:utf-8
class Api::User::AccountController < Api::BaseController

  def show_profile
    render_ok(:profile => @user.profile.as_json)
  end

  def update_profile
    if @user.profile.save_profile(params)
      render_ok(:profile => @user.profile.as_json)
    else
      render_ng(@user.profile.errors)
    end
  end

  def destroy
    @user.destroy
    render_ok
  end
end
