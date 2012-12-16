class Api::PushController < Api::BaseController
  skip_before_filter :check_session_id
  def add
  end
end
