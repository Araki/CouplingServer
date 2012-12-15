# coding:utf-8
class UserController < ApplicationController
  def profile_get
    @users = User.where(:facebook_id => params[:facebook_id])
    if @users != []
      @return = {:success => true, :data => @users}
    else
      @return = {:success => false}
    end
    render :json => @return
  end

  def profile_post
    render :nothing => true, :status => 202
  end

  def list
    @users = User.limit(10)
    @return = {:success => true, :data => @users}
    render :json => @return
  end

  def like_get
    @likes = Like.limit(10)
    @return = {:success => true, :data => @likes}
    render :json => @return
  end

  def like_post
    render :nothing => true, :status => 202
  end

  def favorite_get
    @favorites = Favorite.limit(10)
    @return = {:success => true, :data => @favorites}
    render :json => @return
  end

  def favorite_post
    render :text => 'this is favorite_post'
  end

  def likelist
    @likes = Like.all().limit(10)
    @return = {:success => true, :data => @likes}
    render :json => @return
  end

  def block_get

  end

  def block_post
    render :nothing => true, :status => 202
  end

  def blocklist
  end

  def talk_get
    @return = {
                'talk-2' => {:facebook_id => 12345678,
                             :message => 'こんにちは'},
                'talk-1' => {:facebook_id => 12345678,
                             :message => 'はじめまして'}
               }
    render :json => @return
  end

  def talk_post
    render :nothing => true, :status => 202
  end
end
