# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::User::UsersController do
  before do
    @user = FactoryGirl.create(:user)
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
    @target_user = FactoryGirl.create(:girls)

    FactoryGirl.create_list(:user, 11, {gender: 0})
    FactoryGirl.create_list(:user, 11, {gender: 1})
  end

  describe '#list' do
    # context 'パラメーターを指定しない場合異性が返ること' do
    #   before do
    #     get :list, {session_id: @session.key}
    #   end
    #   subject { JSON.parse(response.body)["users"][0]["gender"] }

    #   it {should == 1}
    # end

    context 'ページを指定した場合' do
      before do
        get :list, {page: 2, per: 7, session_id: @session.key}
      end
      subject { JSON.parse(response.body) }

      its (["current_page"]) {should ==  2}
      its (["last_page"]) {should ==  true}
    end
  end

  describe '#show' do

    context '該当のユーザーが見つかった場合' do
      before do
        get :show, {id: @target_user.id, session_id: @session.key}
      end
      subject { JSON.parse(response.body)["user"] }

      its (["id"]) {should ==  @target_user.id  }
    end

    context '該当のユーザーが見つからなかった場合' do
      before do
        get :show, {id: 1000, session_id: @session.key}
      end
      subject { JSON.parse(response.body) }

      its (["code"]) {should ==  "not_found"}
    end
  end
end
