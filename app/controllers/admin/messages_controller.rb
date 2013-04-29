# -*- coding: utf-8 -*-

#params[:match_id]にtarget_idが入る
class Admin::MessagesController < AdminController

  def index
    @user = User.find(params[:user_id])
    if params[:match_id]
      @match = Match.find_by_user_id_and_target_id(params[:user_id], params[:match_id])
      @messages = Message.by_matches(@match.id, @match.inverse.id).page(params[:page])
    else
      @messages = @user.messages.page(params[:page])
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @user = User.find(params[:user_id])
    @message.destroy
    if params[:match_id]
      match = Match.find(params[:match_id])
      redirect_to admin_user_match_messages_url(@user, match.target.id), :notice => "Successfully destroyed message."
    else
      redirect_to admin_user_messages_url(@user), :notice => "Successfully destroyed message."
    end
  end
end
