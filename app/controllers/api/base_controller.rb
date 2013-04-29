class Api::BaseController < ApplicationController
  before_filter :verify_session

  protected
  def render_ok(entities = {})
    content = {status: 'ok'}
    content = content.merge(entities) unless entities.empty?
    render json: content
  end

  def render_ng(message, ps = nil)
    # code = message.kind_of?(String) ? message : message[:base][0]
    ret = {status: "ng", code: message}
    ret = ret.merge({ps: ps}) if ps
    render json: ret
  end

  def render_pagenate_data(key, data, format)
    render json: {
      :status => 'ok',
      key => data.as_json(format),
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

  def render_users_list(data)
    render_pagenate_data(:users, data, {:only =>[:id, :like_point]})
  end

  def render_not_found
    render_ng('not_found')
  end

  def verify_session
    @session = Session.find_by_key(params[:session_id])
    render_ng('invalid_session') and return if @session.nil?
    
    @user = ::User.find_by_id(@session.value)
    if  @user.present?
      @user.update_attribute(:last_login_at, Time.now)
    else
      @session.destroy
      render_ng('invalid_session') and return if @user.nil?    
    end
  end
end
