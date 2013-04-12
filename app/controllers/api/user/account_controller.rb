# coding:utf-8
class Api::User::AccountController < Api::BaseController

  def show_profile
    render_ok(:user => @user.as_json(:only => [:id]))
  end

  def update_profile
    begin
      @user.profile.update_attributes!(params[:user][:profile])
    rescue Exception => e
      render_ng(e.message)
    else
      render_ok(:user => @user.as_json(:only => [:id]))
    end
  end

  def destroy
    @user.destroy
    render_ok
  end
end
