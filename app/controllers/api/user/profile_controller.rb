# coding:utf-8
class Api::User::ProfileController < Api::User::BaseController
  def show
    render_ok(@user.to_hash)
  end

  def edit
    render_ok(@user.to_hash)
  end

end
