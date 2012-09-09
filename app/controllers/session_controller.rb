class SessionController < ApplicationController
  def register
    if params[:facebook_id] == '10001' && params[:access_token] == 'access_token'
      @return = {:success => :true, 
                 :login_token => 'xxxxx', 
                 :session_id => 'yyyyy'}
    else
      @return = {:success => :false}
    end
    render :json => @return
  end

  def create
    if params[:facebook_id] == '10001' && params[:login_token] == 'login_token'
      @return = {:success=> :true, 
                 :session_id => 'xxxxx'}
    else
      @return = {:success => :false}
    end
    render :json => @return
  end

  def destroy
    reset_session
    @return = {:success => :true}
    render :json => @return
  end
end
