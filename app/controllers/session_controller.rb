class SessionController < ApplicationController
  skip_before_filter :check_session_id, :only => [:register, :create]

  #初期登録。FacebookIDとアクセストークンを渡すと
  #ログイントークン（パスワード）とセッションIDを返す
  def register
    @user = User.where(:facebook_id => params[:facebook_id]).first
    #FacebookIDのレコードがすでに存在する場合(上書き)
    #TODO FacebookAPIを使ってアクセストークンを使ってデータが取得できることを確認する
    if @user != []
      @user.access_token = params[:access_token]
      @user.login_token = SecureRandom.hex(10)
      @user.save
    #レコードがまだ無い場合(新規作成)
    else 
      @user = User.new
      @user.facebook_id = params[:facebook_id]
      @user.access_token = params[:access_token]
      @user.login_token = SecureRandom.hex(10)
      @user.save
    end
    create_session_id
    @return = {:success => :true, 
               :session_id => @my_session.session_id, 
               :user_id => @user.id}
    render :json => @return
  end

  def show
    render :text => @my_session.body
  end

  #いわゆるログイン。FacebookIDとログイントークンを渡すと
  #セッションIDを返す
  def create
    @user = User.where(:facebook_id => params[:facebook_id], :login_token => params[:login_token]).first
    logger.debug(@user.inspect)
    if @user != nil
      create_session_id
      @return = {:success=> true, 
                 :session_id => @my_session.session_id}
    else
      @return = {:success => false}
    end
    render :json => @return
  end

  #ログアウト。セッションを破棄する
  def destroy
    @my_session.destroy
    @return = {:success => true}
    render :json => @return
  end

  private
  def create_session_id
    @my_session = MySession.new
    @my_session.session_id = SecureRandom.hex(4)
    @my_session.body = @user.id
    @my_session.save()
  end
end
