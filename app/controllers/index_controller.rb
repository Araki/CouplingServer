# IndexController
# Author: Naoyuki Yamada

# トップページ

class IndexController < ApplicationController
  # トップページ
  def index
    render :text => "hello rails via cap"
  end

  # 2枚目のページ
  # ===Paramaters
  # *+id+ ID パラメータ
  def top
    render :text => "this is top. param is :" + params[:id]
  end

  def facebook
    
  end
end
