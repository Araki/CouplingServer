# -*- coding: utf-8 -*-
class Api::User::SessionsController < Api::BaseController
  skip_before_filter :verify_session, :only => [:create]

  def create
    render_ng('invalid_access_token') and return unless params[:access_token]

    begin
      @user = User.create_or_find_by_access_token(params[:access_token])
    rescue Exception => e
      ActiveRecord::Rollback
      render_ng("internal_server_error") and return
    else
      @session = Session.create_session(@user)
      render_ok(user_hash)
    end
  end

  #セッションIDをverifyする
  def verify
    if @login_bonus > 0
      @user.update_attribute(:point, @user.point + @login_bonus)
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
      :user => @user.as_json(:except => [:email, :facebook_id, :access_token, :point]),
      :login_bonus => @login_bonus
    }
  end
end