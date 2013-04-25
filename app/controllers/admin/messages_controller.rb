# -*- coding: utf-8 -*-

#params[:match_id]にprofile_idが入る
class Admin::MessagesController < AdminController

  def index
    @user = User.find(params[:user_id])
    if params[:match_id]
      @match = Match.find_by_user_id_and_profile_id(params[:user_id], params[:match_id])
      @messages = @match.talks(nil).page(params[:page])
    else
      @messages = Message.by_user(@user).page(params[:page])
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @user = User.find(params[:user_id])
    @message.destroy
    if params[:match_id]
      redirect_to admin_user_match_messages_url(@user, params[:match_id]), :notice => "Successfully destroyed message."
    else
      redirect_to admin_user_messages_url(@user), :notice => "Successfully destroyed message."
    end
  end
end
