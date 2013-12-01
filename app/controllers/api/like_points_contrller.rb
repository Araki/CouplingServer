class Api::LikePointsController < Api::BaseController
  
  def add
    if @user.add_like_point(params[:amount].to_i)
      render_ok({user: @user})
    else
      render_ng(@user.errors)
    end
  end

  def consume
    if @user.consume_like_point(params[:amount].to_i)
      render_ok({user: @user})
    else
      render_ng(@user.errors)
    end
  end
end
