class Api::PointsController < Api::BaseController
  
  def add
    if @user.add_point(params[:amount].to_i)
      render_ok({user: @user})
    else
      render_ng(@user.errors)
    end
  end

  def consume
    if @user.consume_point(params[:amount].to_i)
      render_ok({user: @user})
    else
      render_ng(@user.errors)
    end
  end
end
