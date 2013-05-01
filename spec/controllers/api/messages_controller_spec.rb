# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::MessagesController do
  include Helpers

  before do
    @user = FactoryGirl.create(:user)
    FactoryGirl.create(:profile, {user: @user, nickname: 'akira'})
    @target = FactoryGirl.create(:user)
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  describe '#list' do
    context 'matchの関係がない場合' do
      before do
        get :list, {target_id: 100, session_id: @session.key}
      end

      it {JSON.parse(response.body)["code"].should == "Api::BaseController::PermissionDenied"}
    end

    context 'matchの関係がある場合' do
      before do
        @match = FactoryGirl.create(:match, {user: @user, target: @target})
        @inverse_match =  FactoryGirl.create(:match, {user: @target, target: @user}) 

        @messages = FactoryGirl.create_list(:message, 5, {match: @match, body: 'dadada'})
        @replys = FactoryGirl.create_list(:message, 5, {match: @inverse_match})
      end

      context '特定のユーザーとのチャットが返ること' do
        before do
          get :list, {target_id: @target.id, session_id: @session.key}
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
          get :list, {target_id: @target.id, page: 2, per: 7, session_id: @session.key}
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
        post :create, {target_id: 100, body: 'lalala', session_id: @session.key}
      end

      it {JSON.parse(response.body)["code"].should == "Api::BaseController::PermissionDenied"}
    end

    context 'matchの関係がある場合' do
      before do
        @match = FactoryGirl.create(:match, {user: @user, target: @target})
        @inverse_match =  FactoryGirl.create(:match, {user: @target, target: @user}) 

        @messages = FactoryGirl.create_list(:message, 5, {match: @match, body: 'dadada'})
        @replys = FactoryGirl.create_list(:message, 5, {match: @inverse_match})
      end

      context '正常な値を送った場合' do
        before do
          @server = Grocer.server(port: 2195)
          @server.accept # starts listening in background
          post :create, {target_id: @target.id, body: 'lalala', session_id: @session.key}
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
          post :create, {target_id: @target.id, body: '', session_id: @session.key}
        end

        it { JSON.parse(response.body)["code"].should_not be_nil }
      end      
    end
  end
end