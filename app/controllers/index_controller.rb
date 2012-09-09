class IndexController < ApplicationController
  def index
    render :text => "hello rails"
  end

  def top
    render :text => "this is top. param is :" + params[:id]
  end
end
