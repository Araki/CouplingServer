# -*- coding: utf-8 -*-
class Api::SessionController < Api::BaseController
  skip_before_filter :check_session_id, :only => [:register]

  #初期登録。FacebookIDとアクセストークンを渡すと
  #ログイントークン（パスワード）とセッションIDを返す
  def register
    @user = User.where(:access_token => params[:access_token]).first
    #レコードがまだ無い場合(新規作成)
    if @user == nil
      @user = User.new
      @graph = Koala::Facebook::API.new(params[:access_token])
      @facebook_profile = @graph.get_object("me")  
      @user.access_token = params[:access_token]
      @user.facebook_id = @facebook_profile["id"]
      @user.save
    #対応するアクセストークンのレコードがすでに存在する場合(上書き)
    #TODO FacebookAPIを使ってアクセストークンを使ってデータが取得できることを確認する
    end
    @session = Session.create_session
    render_ok({session_id: @session.key, facebook_id: @user.id})
  end

  #セッションIDをverifyする
  def verify
    render_ok({session_id: @session.key, body: @session.value})
  end

  #ログアウト。セッションを破棄する
  def destroy
    @session.destroy
    render_ok
  end
end
