class Api::MessagesController < Api::BaseController
  before_filter :load_match
  
  def list
    talks = Kaminari.paginate_array(Message.by_matches(@match.id, @match.inverse.id).since(params[:since_id])).page(params[:page]).per(params[:per])
    @match.update_attribute(:last_read_at, Time.now)

    render_pagenate_data(:messages, talks, {:include => :match})
  end

  def create
    message = Message.new({ body: params[:body], match_id: @match.id, user_id: @match.user_id })
    message.save_message(@match)
    render_ok
    push_notification(@match.target, "#{@user.profile.nickname}: #{params[:body]}")
  end

private

  def load_match
    @match = Match.find_by_user_id_and_target_id(@user.id, params[:target_id].to_i)
    raise PermissionDenied unless @match.present?
  end
end
