# -*- coding: utf-8 -*-
class Api::User::SessionController < Api::User::BaseController
  skip_before_filter :verify_session, :only => [:create]

  #初期登録。FacebookIDとアクセストークンを渡すと
  #ログイントークン（パスワード）とセッションIDを返す
  def create
    begin
      @user = ::User.find_by_access_token(params[:access_token])
      if @user.nil?
        #レコードがまだ無い場合(新規作成)
        @user = ::User.new
        @graph = Koala::Facebook::API.new(params[:access_token])
        @facebook_profile = @graph.get_object("me")  
        @user.access_token = params[:access_token]
        @user.facebook_id = @facebook_profile["id"]
        @user.save!
      end
    #対応するアクセストークンのレコードがすでに存在する場合(上書き)
    #TODO FacebookAPIを使ってアクセストークンを使ってデータが取得できることを確認する
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
      :user => @user.to_hash,
    }
  end
end
