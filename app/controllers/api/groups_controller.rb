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
    render_ng("internal_server_error") and return if @user.group.present?

    params[:group][:user_id] = @user.id
    group = Group.new(params[:group])
    if group.save_group(params)
      render_ok({group: group})
    else
      render_ng(group.errors)
    end
  end

  def update
    render_not_found and return unless @user.group.present?

    if @user.group.save_group(params)
      render_ok({group: @user.group})
    else
      render_ng(@user.group.errors)
    end
  end  
end
