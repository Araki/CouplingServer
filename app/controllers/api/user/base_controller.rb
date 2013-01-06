class Api::User::BaseController < Api::BaseController
  before_filter :verify_session

  protected
  def verify_session
    @session = Session.find_by_key(params[:session_id])
    render_ng('invalid_session') and return if @session.nil?    
    @user = ::User.find_by_id(@session.value)
  end
end
