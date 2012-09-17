class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_session_id

  private
  def check_session_id
    @my_session = MySession.find_by_session_id(params[:session_id])
    if @my_session == nil
      render :json => {:success => false, :reason => 'session id not found.'}
    end
  end
end
