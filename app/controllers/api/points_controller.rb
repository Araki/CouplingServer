class Api::PointsController < Api::BaseController
  
  def add
    @user.add_point(params[:amount].to_i)
    render_ok({user: @user})
  end

  def consume
    @user.consume_point(params[:amount].to_i)
    render_ok({user: @user})
  end
end
