class Api::GroupsController < Api::BaseController
  
  def show
    render_ok({group: @user.group})
  end

  def list
    groups = Group.page(params[:page]).per(params[:per])

    render_pagenate_data(:groups, groups, {})
  end

  def search
    params[:gender] = @user.profile.gender == 0 ? 1 : 0
    groups = Group.search(params).page(params[:page]).per(params[:per])

    render_pagenate_data(:groups, groups, {})
  end

  def create
    raise Exception if @user.group.present?

    params[:group][:user_id] = @user.id
    group = Group.new(params[:group])
    group.save_group(params)
    render_ok({group: group})
  end

  def update
    raise ActionController::RoutingError.new('Group Not Found') if @user.group.nil?

    @user.group.save_group(params)
    render_ok({group: @user.group})
  end  
end
