# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::LikesController do
  include Helpers

  before do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, {user_id: @user.id})
    @target_user = FactoryGirl.create(:user)
    @target_user_profile = FactoryGirl.create(:profile, {user_id: @target_user.id})
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  describe '#list' do
    context 'いいねしたユーザーが見つかった場合' do
      before do
        10.times do
          profile = FactoryGirl.create(:female_profile)
          FactoryGirl.create(:like, {user_id: @user.id, profile_id: profile.id})
        end
      end

      context 'ユーザーのリストが返ること' do
        before do
          get :list, {session_id: @session.key}
        end

        it do
          # response.body.should ==  ''
          parsed_body = JSON.parse(response.body)
          parsed_body["current_page"].should == 1
          parsed_body["profiles"].length.should == 10
          parsed_body["last_page"].should == true
          parsed_body["profiles"][0]["id"].should_not be_nil
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

    context 'いいねをしてくれたユーザーが見つかった場合' do
      before do
        10.times do
          user = FactoryGirl.create(:user)
          profile = FactoryGirl.create(:female_profile, {user_id: user.id})
          FactoryGirl.create(:like, {user_id: user.id, profile_id: @user.profile.id})
        end
      end

      context 'いいねをしてくれたユーザーが見つかった場合' do
        before do
          get :list, {type: 'liked', session_id: @session.key}
        end

        it 'ユーザーのリストが返ること' do
          # response.body.should ==  ''
          parsed_body = JSON.parse(response.body)
          parsed_body["current_page"].should == 1
          parsed_body["profiles"].length.should == 10
          parsed_body["last_page"].should == true
          parsed_body["profiles"][0]["id"].should_not be_nil
          parsed_body["profiles"][0]["email"].should be_nil
        end
      end

      context 'pageを指定した場合' do
        before do
          get :list, {type: 'liked', page: 2, per: 7, session_id: @session.key}
        end

        it 'ページネーションされること' do
          parsed_body = JSON.parse(response.body)
          parsed_body["current_page"].should == 2
          parsed_body["profiles"].length.should == 3
          parsed_body["last_page"].should == true
        end
      end    
    end    
  end

  describe '#create' do
    context '正常な値がPOSTされた場合' do
      context 'いいねが存在していないと' do
        it 'いいねが作成されること' do
          expect{
            post :create, {profile_id: @target_user_profile.id, session_id: @session.key}
          }.to change(Like, :count).by(1)
        end
      end

      context 'いいねが存在していないと2' do
        before do
          post :create, {profile_id: @target_user_profile, session_id: @session.key}
        end

        it 'okが返されること' do
          JSON.parse(response.body)["status"].should == "ok"
        end 
      end

      context '作成に失敗すると' do
        before do
          user = session_verified_user(@session)
          User.should_receive(:find_by_id).with(@user.id.to_s).and_return(user)
          profile = mock('profile')
          profile.should_receive(:gender).and_return(0)
          user.should_receive(:profile).and_return(profile)
          user.should_receive(:over_likes_limit_per_day?).and_return(false)
          user.stub!(:create_like).with(@target_user_profile).and_return({message: "internal_server_error"})          

          post :create, {profile_id: @target_user_profile.id, session_id: @session.key}
        end

        it 'internal_server_errorが返されること' do
          JSON.parse(response.body)["code"].should == "internal_server_error"
        end 
      end

      context '当日の作成数の上限を超えていると' do
        before do
          user = session_verified_user(@session)
          profile = mock('profile')
          profile.should_receive(:gender).and_return(0)
          user.should_receive(:profile).and_return(profile)
          user.should_receive(:over_likes_limit_per_day?).and_return(true)
 
          post :create, {profile_id: @target_user_profile.id, session_id: @session.key}
        end

        it 'over_limitが返されること' do
          JSON.parse(response.body)["code"].should == "over_limit"
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
end