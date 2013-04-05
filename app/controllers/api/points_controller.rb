class Api::PointsController < Api::BaseController
  
  def add
    result = @user.add_point(params[:amount].to_i)
    result.has_key?(:point) ? render_ok(result) : render_ng(result[:message])
  end

  def consume
    result = @user.consume_point(params[:amount].to_i)
    result.has_key?(:point) ? render_ok(result) : render_ng(result[:message])
  end
end
