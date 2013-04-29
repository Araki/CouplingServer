class Api::InfosController < Api::BaseController
  
  def list
    infos = Info.by_target_user(@user).after_created_at(@user.check_info_at).page(params[:page]).per(params[:per])
    @user.update_attribute(:check_info_at, Time.now)

    render_pagenate_data(:infos, infos, {})
  end
end
