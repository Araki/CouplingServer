# coding:utf-8
class Api::User::ProfileController < Api::User::BaseController
  def show
    if user_id = params[:user_id]
      target_user = User.find_by_id(user_id)
    else
      target_user = @user
    end
    render_not_found and return unless target_user
    render_ok(target_user.to_hash)
  end

  def edit
    @user.prefecture   = params[:prefecture]
    @user.introduction = params[:introduction]
    @user.birthplace   = params[:birthplace]
    @user.blood_type   = params[:blood_type]
    @user.height       = params[:height]
    @user.propotion    = params[:propotion]
    @user.school       = params[:school]
    @user.school_name  = params[:school_name]
    @user.job          = params[:job]
    @user.income       = params[:income]
    @user.holiday      = params[:holiday]
    @user.hobby        = params[:hobby]
    @user.character    = params[:character]
    @user.roommate     = params[:roommate]
    @user.smoking      = params[:smoking]
    @user.alcohol      = params[:alcohol]

    if @user.save
      render_ok
    else
      render_ng(@user.errors.full_messages)
    end
    render_ok(@user.to_hash)
  end

end
