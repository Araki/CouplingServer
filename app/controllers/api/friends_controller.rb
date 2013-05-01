class Api::FriendsController < Api::BaseController
  
  def show
    friend = Friend.find(params[:id])
    
    render_ok({friend: friend})
  end
  
  def create
    raise ActionController::RoutingError.new('Group Not Found') if @user.group.nil?

    friend = Friend.new(params[:friend])
    @user.group.friends << friend
    friend.save_profile(params)

    render_ok({friend: friend})
  end

  def update
    friend = Friend.find(params[:id])
    raise ActionController::RoutingError.new('Group Not Found') if @user.group.nil?
    raise PermissionDenied unless friend.group == @user.group

    friend.save_profile(params)

    render_ok({friend: friend})
  end  

  def destroy
    friend = Friend.find(params[:id])
    raise ActionController::RoutingError.new('Group Not Found') if @user.group.nil?
    raise PermissionDenied unless friend.group == @user.group

    friend.destroy

    render_ok
  end  
end
