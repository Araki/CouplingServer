# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::MatchesController do
  include Helpers

  before do
    @user = FactoryGirl.create(:user)
    @target = FactoryGirl.create(:target)
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })

    10.times do
      target = FactoryGirl.create(:target)
      FactoryGirl.create(:profile, {user:  target})
      FactoryGirl.create(:match, {user_id: @user.id, target_id: target.id})
    end
  end

  describe '#list' do
    context 'マッチしたユーザーが見つかった場合' do
      before do
        get :list, {session_id: @session.key}
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
end