# IndexController
# Author: Naoyuki Yamada

# トップページ

class IndexController < ApplicationController
  skip_before_filter :check_session_id

  def index
    render :text => "hello"
  end
end
