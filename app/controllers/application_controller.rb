class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_session_id

  private
  def check_session_id
    @session = Session.where(:key => params[:session_id]).first
    if @session == nil
      render :json => {:success => false, :message => 'session_id not found.'}
    end
  end
end
