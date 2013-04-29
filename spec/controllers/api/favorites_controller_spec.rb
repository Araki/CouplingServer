# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::FavoritesController do
  include Helpers

  before do
    @user = FactoryGirl.create(:user)
    @target = FactoryGirl.create(:user)
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  describe '#list' do
    before do
      10.times do
        target = FactoryGirl.create(:target)
        FactoryGirl.create(:profile, {user:  target})
        FactoryGirl.create(:favorite, {user: @user, target: target})
      end
    end

    context 'お気に入りが見つかった場合' do
      before do
        get :list, {session_id: @session.key}
      end

      it 'お気に入りユーザーのリストが返ること' do
        parsed_body = JSON.parse(response.body)
        parsed_body["current_page"].should == 1
        parsed_body["profiles"].length.should == 10
        parsed_body["last_page"].should == true
        parsed_body["profiles"][0]["nickname"].should_not be_nil
        parsed_body["profiles"][0]["email"].should be_nil
      end
    end

    context 'pageを指定した場合' do
      before do
        get :list, {page: 2, per: 7, session_id: @session.key}
      end

      it 'ページネーションされること' do
        parsed_body = JSON.parse(response.body)
        parsed_body["current_page"].should == 2
        parsed_body["profiles"].length.should == 3
        parsed_body["last_page"].should == true
      end
    end
  end

  describe '#create' do
    context '正常な値がPOSTされた場合' do
      context 'お気に入りが存在していないと' do
        it 'お気に入りが作成されること' do
          expect{
            post :create, {target_id: @target.id, session_id: @session.key}
          }.to change(Favorite, :count).by(1)
        end
      end

      context 'okが返されること' do
        before do
          post :create, {target_id: @target, session_id: @session.key}
        end

        it {JSON.parse(response.body)["status"].should == "ok"}
      end

      context '保存に失敗すると' do
        before do
          user = session_verified_user(@session)
          user.stub!(:<<).with(@target).and_raise(Exception)
          User.should_receive(:find_by_id).with(@user.id.to_s).and_return(user)      
          User.should_receive(:find_by_id).with(@target.id.to_s).and_return(@target)      

          post :create, {target_id: @target.id, session_id: @session.key}
        end

        it 'internal_server_errorが返されること' do
          JSON.parse(response.body)["code"].should == "internal_server_error"
        end 
      end
    end

    context '相手が存在しない場合' do
      before do
        post :create, {target_id: 200, session_id: @session.key}
      end

      it 'not_foundが返されること' do
        JSON.parse(response.body)["code"].should == "not_found"
      end 
    end
  end

  describe '#destroy' do
    before do
      @user.favorite_users << @target
    end

    context 'お気に入りが見つかった場合' do
      it '削除されること' do
        expect{
          post :destroy, {target_id: @target.id, session_id: @session.key}
        }.to change(Favorite, :count).by(-1)
      end
    end

    context 'okが返されること' do
      before do
        user = session_verified_user(@session)
        User.should_receive(:find_by_id).with(@user.id.to_s).and_return(user)
        User.should_receive(:find_by_id).with(@target.id.to_s).and_return(@target)
        user.stub!(:favorite_users).and_return([@target])
        [@target].stub!(:delete).with(@target)

        post :destroy, {target_id: @target.id, session_id: @session.key}
      end

      it {JSON.parse(response.body)["status"].should == "ok"}
    end
  end
end