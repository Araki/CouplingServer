class Api::BaseController < ApplicationController
  protected
  def render_ok(entities = {})
    content = {status: 'ok'}
    content = content.merge(entities) unless entities.empty?
    render json: content
  end

  def render_ng(message, ps = nil)
    ret = {status: "ng", code: message}
    ret = ret.merge({ps: ps}) if ps
    render json: ret
  end

  def render_not_found
    render_ng('not_found')
  end
end
