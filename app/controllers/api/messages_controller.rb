class Api::MessagesController < Api::BaseController
  
  def list
    match = Match.find_by_user_id_and_target_id(@user.id, params[:target_id].to_i)
    render_ng("permission_denied") and return unless match.present?

    talks = Kaminari.paginate_array(match.talks(params[:since_id])).page(params[:page]).per(params[:per])

    render_pagenate_data(:messages, talks, {:include => :match})
  end

  def create
    match = Match.find_by_user_id_and_target_id(@user.id, params[:target_id].to_i)
    render_ng("permission_denied") and return unless match.present?

    if match.create_message({body: params[:body]})
      render_ok
    else
      render_ng("internal_server_error")
    end
  end
end
