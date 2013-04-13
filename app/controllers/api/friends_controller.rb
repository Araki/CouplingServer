class Api::FriendsController < Api::BaseController
  
  def create
    render_ng("internal_server_error") and return if @user.group.nil?

    friend = Friend.new(params[:friend])
    @user.group.friends << friend
    if friend.save
      render_ok({friend: friend})
    else
      render_ng(friend.errors)
    end
  end

  def update
    friend = Friend.find_by_id(params[:id])
    render_not_found and return if friend.nil?
    render_ng("internal_server_error") and return if @user.group.nil?
    render_ng("permission_denied") and return unless friend.group == @user.group

    if friend.update_attributes(params[:friend])
      render_ok({friend: friend})
    else
      render_ng(friend.errors)
    end
  end  

  def destroy
    friend = Friend.find_by_id(params[:id])
    render_not_found and return if friend.nil?
    render_ng("internal_server_error") and return if @user.group.nil?
    render_ng("permission_denied") and return unless friend.group == @user.group

    friend.destroy
    render_ok
  end  
end
