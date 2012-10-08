class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_session_id

  private
  def check_session_id
    @session = Session.find_by_key(params[:session_id])
    if @session == nil
      render :json => {:success => false, :message => 'session_id not found.'}
    end
  end
end
