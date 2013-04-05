# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::MessagesController do
  before do
    @user = FactoryGirl.create(:user)
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })

    @target_user = FactoryGirl.create(:user, {gender: 1, nickname: 'atsuko'})
  end

  describe '#list' do
    it '女性の場合の本人確認の有無'

    context 'matchの関係がない場合' do
      before do
        get :list, {target_id: @target_user.id, session_id: @session.key}
      end

      it {JSON.parse(response.body)["code"].should == "permission_denied"}
    end

    context 'matchの関係がある場合' do
      before do
        @match = FactoryGirl.create(:match, {user_id: @user.id, target_id: @target_user.id})
        @oppsite_match =  FactoryGirl.create(:match, {user_id: @target_user.id, target_id: @user.id}) 

        @messages = FactoryGirl.create_list(:message, 5, {match_id: @match.id, talk_key: @match.talk_key, body: 'dadada'})
        @replys = FactoryGirl.create_list(:message, 5, {match_id: @oppsite_match.id, talk_key: @oppsite_match.talk_key})
      end

      context '特定のユーザーとのチャットが返ること' do
        before do
          get :list, {target_id: @target_user.id, session_id: @session.key}
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
          get :list, {target_id: @target_user.id, page: 2, per: 7, session_id: @session.key}
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
        post :create, {target_id: @target_user.id, body: 'lalala', session_id: @session.key}
      end

      it {JSON.parse(response.body)["code"].should == "permission_denied"}
    end

    context 'matchの関係がある場合' do
      before do
        @match = FactoryGirl.create(:match, {user_id: @user.id, target_id: @target_user.id})
        @oppsite_match =  FactoryGirl.create(:match, {user_id: @target_user.id, target_id: @user.id}) 

        @messages = FactoryGirl.create_list(:message, 5, {match_id: @match.id, talk_key: @match.talk_key, body: 'dadada'})
        @replys = FactoryGirl.create_list(:message, 5, {match_id: @oppsite_match.id, talk_key: @oppsite_match.talk_key})
      end

      context '正常な値を送った場合' do
        before do
          post :create, {target_id: @target_user.id, body: 'lalala', session_id: @session.key}
        end

        it {JSON.parse(response.body)["status"].should == "ok"}
      end

      context 'messageを作成できなかった場合' do
        before do
          match = mock(:match)
          Match.should_receive(:find_by_user_id_and_target_id).with(@user.id, @target_user.id).and_return(match)
          match.should_receive(:present?).and_return(true)
          match.should_receive(:create_message).with({body: 'lalala'}).and_return(false)

          post :create, {target_id: @target_user.id, body: 'lalala', session_id: @session.key}
        end

        it { JSON.parse(response.body)["code"].should == "internal_server_error" }
      end      
    end
  end
end