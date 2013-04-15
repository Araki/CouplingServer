class Api::MessagesController < Api::BaseController
  
  def list
    match = Match.find_by_user_id_and_profile_id(@user.id, params[:profile_id].to_i)
    render_ng("permission_denied") and return unless match.present?

    talks = Kaminari.paginate_array(match.talks(params[:since_id])).page(params[:page]).per(params[:per])

    render_pagenate_data(:messages, talks, {:include => :match})
  end

  def create
    match = Match.find_by_user_id_and_profile_id(@user.id, params[:profile_id].to_i)
    render_ng("permission_denied") and return unless match.present?

    message = Message.new(:match_id => match.id, :body => params[:body], :talk_key => match.talk_key )
    if message.count_and_save(match)
      render_ok
    else
      render_ng(message.errors)
    end
  end
end
