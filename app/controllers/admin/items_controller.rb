# coding:utf-8
class Admin::ItemsController < Api::BaseController
  def list
    #TODO 管理者のみに公開できること
    items = Item.all
  end

  def edit
  end

  def create
  end
end
