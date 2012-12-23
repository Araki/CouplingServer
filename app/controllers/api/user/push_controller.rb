class Api::User::PushController < Api::User::BaseController
  skip_before_filter :check_session_id
  def add
  end
end
