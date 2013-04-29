class Api::MessagesController < Api::BaseController
  
  def list
    match = Match.find_by_user_id_and_target_id(@user.id, params[:target_id].to_i)
    render_ng("permission_denied") and return unless match.present?

    talks = Kaminari.paginate_array(Message.by_matches(match.id, match.inverse.id).since(params[:since_id])).page(params[:page]).per(params[:per])
    match.update_attribute(:last_read_at, Time.now)

    render_pagenate_data(:messages, talks, {:include => :match})
  end

  def create
    match = Match.find_by_user_id_and_target_id(@user.id, params[:target_id].to_i)
    render_ng("permission_denied") and return unless match.present?

    message = Message.new({
        body: params[:body],
        match_id: match.id,
        user_id: match.user_id
        })
    if message.save_message(match)
      render_ok
      push_notification(match.target, "#{@user.profile.nickname}: #{params[:body]}")
    else
      render_ng(message.errors)
    end
  end
end
