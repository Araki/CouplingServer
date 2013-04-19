# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::MessagesController do
  before do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, {user_id: @user.id, nickname: 'akira'})
    @target_user = FactoryGirl.create(:user)
    @target_user_profile = FactoryGirl.create(:profile, {user_id: @target_user.id})
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  describe '#list' do
    context 'matchの関係がない場合' do
      before do
        get :list, {profile_id: @target_user_profile.id, session_id: @session.key}
      end

      it {JSON.parse(response.body)["code"].should == "permission_denied"}
    end

    context 'matchの関係がある場合' do
      before do
        @match = FactoryGirl.create(:match, {user_id: @user.id, profile_id: @target_user_profile.id})
        @oppsite_match =  FactoryGirl.create(:match, {user_id: @target_user_profile.id, profile_id: @user.id}) 

        @messages = FactoryGirl.create_list(:message, 5, {match_id: @match.id, talk_key: @match.talk_key, body: 'dadada'})
        @replys = FactoryGirl.create_list(:message, 5, {match_id: @oppsite_match.id, talk_key: @oppsite_match.talk_key})
      end

      context '特定のユーザーとのチャットが返ること' do
        before do
          get :list, {profile_id: @target_user_profile.id, session_id: @session.key}
        end

        it do
          # response.body.should ==  ''
          parsed_body = JSON.parse(response.body)
          parsed_body["current_page"].should == 1
          parsed_body["messages"].length.should == 10
          parsed_body["last_page"].should == true
          parsed_body["messages"][0]["body"].should == 'dadada'
        end
      end

      context 'pageを指定した場合' do
        before do
          get :list, {profile_id: @target_user_profile.id, page: 2, per: 7, session_id: @session.key}
        end

        it do
          parsed_body = JSON.parse(response.body)
          parsed_body["current_page"].should == 2
          parsed_body["messages"].length.should == 3
          parsed_body["last_page"].should == true
        end
      end
    end
  end

  describe '#create' do
    context 'matchの関係がない場合' do
      before do
        post :create, {profile_id: @target_user_profile.id, body: 'lalala', session_id: @session.key}
      end

      it {JSON.parse(response.body)["code"].should == "permission_denied"}
    end

    context 'matchの関係がある場合' do
      before do
        @match = FactoryGirl.create(:match, {user_id: @user.id, profile_id: @target_user_profile.id})
        @oppsite_match =  FactoryGirl.create(:match, {user_id: @target_user_profile.id, profile_id: @user.id}) 

        @messages = FactoryGirl.create_list(:message, 5, {match_id: @match.id, talk_key: @match.talk_key, body: 'dadada'})
        @replys = FactoryGirl.create_list(:message, 5, {match_id: @oppsite_match.id, talk_key: @oppsite_match.talk_key})
      end

      context '正常な値を送った場合' do
        before do
          @server = Grocer.server(port: 2195)
          @server.accept # starts listening in background
          post :create, {profile_id: @target_user_profile.id, body: 'lalala', session_id: @session.key}
        end

        after do
          @server.close
        end

        it {JSON.parse(response.body)["status"].should == "ok"}

        it do
          notification = @server.notifications.pop
          expect(notification.alert).to eq("akira: lalala")
        end
      end

      context 'messageを作成できなかった場合' do
        before do
          post :create, {profile_id: @target_user_profile.id, body: '', session_id: @session.key}
        end

        it { JSON.parse(response.body)["code"]["base"][0].should == "internal_server_error" }
      end      
    end
  end
end