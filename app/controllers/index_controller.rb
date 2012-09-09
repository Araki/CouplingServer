# IndexController
# Author: Naoyuki Yamada

# トップページ

class IndexController < ApplicationController
  # トップページ
  def index
    render :text => "hello rails"
  end

  # 2枚目のページ
  # ===Paramaters
  # *+id+ ID パラメータ
  def top
    render :text => "this is top. param is :" + params[:id]
  end
end
