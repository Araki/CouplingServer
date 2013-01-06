# coding:utf-8
class Api::User::UserController < Api::User::BaseController
  def list
    limit = params[:limit] ? params[:limit] : 10
    offset = params[:offset] ? params[:offset] : 0
    gender = @user.gender == 0 ? 1 : 0
    users = User.where(gender: gender).offset(offset).limit(limit).map(&:to_hash)
    render_ok(user: users)
  end

  def favorite_get
    @favorites = Favorite.limit(10)
    render_ok(@favorites)
  end

  def favorite_post
    render :text => 'this is favorite_post'
  end

  def talk_get
    return_hash = {
                'talk-2' => {:facebook_id => 12345678,
                             :message => 'こんにちは'},
                'talk-1' => {:facebook_id => 12345678,
                             :message => 'はじめまして'}
               }
    render_ok(return_hash)
  end

  def talk_post
    render_ok
  end
end
