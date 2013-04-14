class Api::InfosController < Api::BaseController
  
  def list
    infos = Kaminari.paginate_array(@user.infos).page(params[:page]).per(params[:per])

    render_pagenate_data(:infos, infos, {})
  end
end
