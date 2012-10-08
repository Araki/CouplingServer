class SessionController < ApplicationController
  skip_before_filter :check_session_id, :only => [:register, :create]

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
      @user.id = @facebook_profile["id"]
      @user.save
    #対応するアクセストークンのレコードがすでに存在する場合(上書き)
    #TODO FacebookAPIを使ってアクセストークンを使ってデータが取得できることを確認する
    end
    create_session_id
    @return = {:success => :true, 
               :session_id => @session.key, 
               :facebook_id => @facebook_profile['id']}
    render :json => @return
  end

  def show
    render :text => @session.body
  end

  #セッションIDをverifyする
  def verify
    @user = User.where(:session_key => params[:session_id]).first
    logger.debug(@user.inspect)
    if @user != nil
      @return = {:success=> true, 
                 :session_id => @session.session_id}
    else
      @return = {:success => false,
                 :message => "session_id not found."}
    end
    render :json => @return
  end

  #ログアウト。セッションを破棄する
  def destroy
    @session.destroy
    @return = {:success => true}
    render :json => @return
  end

  private
  def create_session_id
    @session = Session.new
    @session.key = SecureRandom.hex(4)
    @session.value = @user.id
    @session.save()
  end
end
