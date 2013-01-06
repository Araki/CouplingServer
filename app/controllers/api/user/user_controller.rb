# coding:utf-8
class Api::User::UserController < Api::User::BaseController
  def list
    @users = User.limit(10)
    render_ok(@users)
  end

  def favorite_get
    @favorites = Favorite.limit(10)
    render_ok(@favorites)
  end

  def favorite_post
    render :text => 'this is favorite_post'
  end

  def block_get

  end

  def block_post
    redner_ok
  end

  def blocklist
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
