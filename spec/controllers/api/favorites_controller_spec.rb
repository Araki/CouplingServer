# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::FavoritesController do
  include Helpers

  before do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, {user_id: @user.id})
    @target_user = FactoryGirl.create(:user)
    @target_user_profile = FactoryGirl.create(:profile, {user_id: @target_user.id})
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  describe '#list' do
    before do
      10.times do
        female_profile = FactoryGirl.create(:female_profile)
        FactoryGirl.create(:favorite, {user_id: @user.id, profile_id: female_profile.id})
      end
    end

    context 'お気に入りが見つかった場合' do
      before do
        get :list, {session_id: @session.key}
      end

      it 'お気に入りユーザーのリストが返ること' do
        # response.body.should ==  ''
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
            post :create, {profile_id: @target_user_profile.id, session_id: @session.key}
          }.to change(Favorite, :count).by(1)
        end
      end

      context 'okが返されること' do
        before do
          post :create, {profile_id: @target_user_profile, session_id: @session.key}
        end

        it {JSON.parse(response.body)["status"].should == "ok"}
      end

      context '保存に失敗すると' do
        before do
          user = session_verified_user(@session)
          user.stub!(:<<).with(@target_user_profile).and_raise(Exception)
          User.should_receive(:find_by_id).with(@user.id.to_s).and_return(user)      

          post :create, {profile_id: @target_user_profile.id, session_id: @session.key}
        end

        it 'internal_server_errorが返されること' do
          JSON.parse(response.body)["code"].should == "internal_server_error"
        end 
      end
    end

    context '相手が存在しない場合' do
      before do
        post :create, {profile_id: 200, session_id: @session.key}
      end

      it 'not_foundが返されること' do
        JSON.parse(response.body)["code"].should == "not_found"
      end 
    end
  end

  describe '#destroy' do
    before do
      @user.favorite_profiles << @target_user_profile
    end

    context 'お気に入りが見つかった場合' do
      it '削除されること' do
        expect{
          post :destroy, {profile_id: @target_user_profile.id, session_id: @session.key}
        }.to change(Favorite, :count).by(-1)
      end
    end

    context 'okが返されること' do
      before do
        user = session_verified_user(@session)
        User.should_receive(:find_by_id).with(@user.id.to_s).and_return(user)
        user.stub!(:favorite_profiles).and_return([@target_user_profile])
        [@target_user_profile].stub!(:delete).with(@target_user_profile)

        post :destroy, {profile_id: @target_user_profile.id, session_id: @session.key}
      end

      it {JSON.parse(response.body)["status"].should == "ok"}
    end
  end
end