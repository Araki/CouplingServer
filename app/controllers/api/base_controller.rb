class Api::BaseController < ApplicationController
  before_filter :verify_session

  class BadRequest < StandardError; end
  class PermissionDenied < StandardError; end

  rescue_from Exception, :with => :render_500
  rescue_from ActiveRecord::RecordInvalid, :with => :render_422
  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound, 
    ActionController::UnknownController, AbstractController::ActionNotFound, :with => :render_404
  rescue_from PermissionDenied, :with => :render_403
  rescue_from BadRequest, :with => :render_400

  protected

  def verify_session
    raise BadRequest.new('session_id required') unless params[:session_id]
    @session = Session.find_by_key(params[:session_id])
    raise BadRequest.new('Session Not Found')  if @session.nil?
    
    @user = ::User.find_by_id(@session.value)
    if  @user.present?
      @user.update_attribute(:last_login_at, Time.now)
    else
      @session.destroy
      raise BadRequest.new('Invalid session. Please create session again.') if @user.nil?    
    end
  end

  def render_ok(entities = {})
    content = {status: 'ok'}
    content = content.merge(entities) unless entities.empty?
    render json: content
  end

  def render_ng(message)
    render json: {status: "ng", code: message}
  end

  def render_pagenate_data(key_name, data, format)
    render json: {
      key_name => data.as_json(format),
      :status => 'ok',
      :current_page => data.current_page,
      :last_page => data.last_page?
    }    
  end

  def render_users_to_profiles_list(data)
    profiles = data.map(&:profile)
    render json: {
      :status => 'ok',
      :profiles => profiles.as_json({}),
      :current_page => data.current_page,
      :last_page => data.last_page?
    }    
  end

  def render_profiles_list(data)
    render_pagenate_data(:profiles, data, {})
  end

  def render_400(exception = nil)
    logger.info "Rendering 400 with exception: #{exception.message}"
    render_ng(exception.message)
  end

  def render_403(exception = nil)
    logger.info "Rendering 403 with exception: #{exception.message}"
    render_ng(exception.message)
  end

  def render_404(exception = nil)
    logger.info "Rendering 404 with exception: #{exception.message}"
    render_ng(exception.message)
  end

  def render_422(exception = nil)
    if exception && exception.record
      logger.info "Rendering 422 with exception: #{exception.record.errors.messages}"
      message = exception.record.errors.messages
    else
      logger.info "unprocessable_entity"
      message = 'unprocessable_entity'
    end
    render_ng(message)
  end

  def render_500(exception = nil)
    message = exception ? exception.message : 'internal_server_error'
    logger.info "Rendering 500 with exception: #{message}"
    render_ng(message)
  end
end
