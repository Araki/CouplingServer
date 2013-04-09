# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::ImagesController do
  include Helpers
  
  before do
    @user = FactoryGirl.create(:user)
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  describe '#list' do
    before do
      FactoryGirl.create_list(:image, 10, {user_id: @user.id, is_main: true})
      FactoryGirl.create_list(:image, 5, {user_id: @user.id, is_main: false})
    end

    context '画像が見つかった場合' do
      before do
        get :list, {session_id: @session.key}
      end

      it 'メイン画像のリストが返ること' do
        # response.body.should ==  ''
        parsed_body = JSON.parse(response.body)
        parsed_body["current_page"].should == 1
        parsed_body["images"].length.should == 10
        parsed_body["last_page"].should == true
      end

      it '画像のURLが含まれること' do
        parsed_body = JSON.parse(response.body)
        parsed_body["images"][0]["url"].should_not be_nil
      end
    end

    context 'pageを指定した場合' do
      before do
        get :list, {page: 2, per: 7, session_id: @session.key}
      end

      it 'ページネーションされること' do
        parsed_body = JSON.parse(response.body)
        parsed_body["current_page"].should == 2
        parsed_body["images"].length.should == 3
        parsed_body["last_page"].should == true
      end
    end
  end

  describe '#create' do
    context 'すでに5枚以上アップロードしている場合' do
      before do
        FactoryGirl.create_list(:image, 5, {user_id: @user.id})
        post :create, {session_id: @session.key}
      end

      it {JSON.parse(response.body)["code"].should == "over_limit"}
    end

    context '画像が５枚以下の場合' do
      before do
        post :create, {session_id: @session.key}
      end

      it 'upload用のパラメーターが返ること' do
        parsed_body = JSON.parse(response.body)
        parsed_body["url"].should == "https://pairful-development.s3.amazonaws.com/"
        parsed_body["fields"]["AWSAccessKeyId"].should == "AKIAIOQ4BVQW426SIRFA"
      end
    end
  end

  describe '#set_main' do
    context '画像が見つからなかった場合' do
      before do
        post :set_main, {id: 1, session_id: @session.key}
      end

      it {JSON.parse(response.body)["code"].should == "not_found"}
    end

    context '自分の画像ではなかった場合' do
      before do
        FactoryGirl.create(:image, {user_id: 100})
        post :set_main, {id: 1, session_id: @session.key}
      end

      it {JSON.parse(response.body)["code"].should == "permission_denied"}
    end

    context 'mainにセットされた場合' do
      before do
        FactoryGirl.create(:image, {user_id: @user.id})
        post :set_main, {id: 1, session_id: @session.key}
      end

      it {JSON.parse(response.body)["status"].should == "ok"}
    end

    context 'mainのセットに失敗すると' do
      before do
        image = FactoryGirl.create(:image, {user_id: @user.id})

        user = session_verified_user(@session)
        user.stub!(:==).with(@user).and_return(true)          
        user.stub!(:set_main_image).with(image).and_return(false)          

        post :set_main, {id: 1, session_id: @session.key}
      end

      it 'internal_server_errorが返されること' do
        JSON.parse(response.body)["code"].should == "internal_server_error"
      end 
    end
  end

  describe '#destroy' do
    context '削除できた場合' do
      before do
        FactoryGirl.create(:image, {user_id: @user.id})
        post :destroy, {id: 1, session_id: @session.key}
      end

      it {JSON.parse(response.body)["status"].should == "ok"}
    end

    context '自分の画像ではなかった場合' do
      before do
        FactoryGirl.create(:image, {user_id: 100})
        post :destroy, {id: 1, session_id: @session.key}
      end

      it {JSON.parse(response.body)["code"].should == "permission_denied"}
    end
  end
end