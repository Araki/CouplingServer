# coding:utf-8
class UserController < ApplicationController
  def profile_get
    @return = {:success => true,
               'user-123456789'=> {:favebook_id=>'123456789',
                                   :gender=>'female',
                                   :birthday=>'1979/7/19',
                                   :hobby=>'123,147,156'}}
    render :json => @return
  end

  def profile_post
    render :nothing => true, :status => 202
  end

  def list
    @return = {:success => true,
                "user-12345" => {:something => 'xxxxx'},
                "user-12346" => {:something => 'xxxxx'},
                "user-12347" => {:something => 'xxxxx'},
                "user-12348" => {:something => 'xxxxx'},
                "user-12349" => {:something => 'xxxxx'}
              }
    render :json => @return
  end

  def like_get
    @return = {:success => true,
                "user-12345" => {:something => 'xxxxx'},
                "user-12346" => {:something => 'xxxxx'},
                "user-12347" => {:something => 'xxxxx'},
                "user-12348" => {:something => 'xxxxx'},
                "user-12349" => {:something => 'xxxxx'}
              }
    render :json => @return
  end

  def like_post
    render :nothing => true, :status => 202
  end

  def likelist
    @return = {:success => true,
                "user-12345" => {:something => 'xxxxx'},
                "user-12346" => {:something => 'xxxxx'},
                "user-12347" => {:something => 'xxxxx'},
                "user-12348" => {:something => 'xxxxx'},
                "user-12349" => {:something => 'xxxxx'}
              }
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
