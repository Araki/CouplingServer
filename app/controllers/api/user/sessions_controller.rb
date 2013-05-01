# -*- coding: utf-8 -*-
class Api::User::SessionsController < Api::BaseController
  skip_before_filter :verify_session, :only => [:create]

  def create
    raise BadRequest.new('access_token required') unless params[:access_token]

    @user = ::User.create_or_find_by_access_token(params[:access_token], params[:device_token])
    @session = Session.create_session(@user)
    render_ok(user_hash)
  end

  #セッションIDをverifyする
  def verify
    if @user.last_verify_at < Date.today
      @login_bonus = configatron.login_bonus
      @user.assign_attributes({point: @user.point + @login_bonus, last_verify_at: Time.now}, :without_protection => true)
      @user.save
    end
    render_ok(user_hash)
  end

  #ログアウト。セッションを破棄する
  def destroy
    @session.destroy
    render_ok
  end

  private

  def user_hash
    {
      :session => @session.key,
      :user => @user.as_json(:only => [:id, :status, :point, :like_point, :last_login_at]),
      :login_bonus => @login_bonus
    }
  end
end
