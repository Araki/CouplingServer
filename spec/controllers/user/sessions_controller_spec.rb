# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::User::SessionsController do
  before do
    @user = FactoryGirl.create(:user, {nickname: 'akira', point: 100})
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  describe '#create' do
    context '有効なアクセストークンが渡された場合' do
      context 'ユーザーが見つかるか作成された場合' do
        before do
          User.stub!(:create_or_find_by_access_token).with('xxx').and_return(@user)
          post :create, {:access_token => 'xxx'}
        end
        subject { JSON.parse(response.body)["user"] }

        its (["nickname"]) {should ==  "akira"}
      end

      context 'ユーザーが見つかるか作成された場合' do
        before do
          User.stub!(:create_or_find_by_access_token).with('xxx').and_return(@user)
        end
        it 'sessionが作成されること' do
          expect{
            post :create, {access_token: 'xxx'}
          }.to change(Session, :count).by(1)
        end
      end

      context 'ユーザーを保存できなかった場合' do
        before do
          User.stub!(:create_or_find_by_access_token).with('abc').and_raise(ActiveRecord::RecordInvalid.new(@user))
          post :create, {:access_token => 'abc'}
        end
        subject { JSON.parse(response.body) }

        its (["code"]) {should ==  "internal_server_error"}
      end
    end

    context 'アクセストークンが無い場合' do
      before do
        post :create, {}
      end
      subject { JSON.parse(response.body) }

      its (["code"]) {should ==  "invalid_access_token"}
    end
  end

  describe '#verify' do
    context 'Sessionが見つからなかった場合' do
      before do
        get :verify, {}
      end      
      subject { JSON.parse(response.body) }

      its (["code"]) {should ==  "invalid_session"}
    end

    context '自分のアカウントが見つかった場合' do
      before do
        get :verify, {:session_id => @session.key}
      end
      subject { JSON.parse(response.body) }

      its (["session"]) {should ==  @session.key}
    end

    context '自分のアカウントが見つからなかった場合' do
      before do
        invalid_session = FactoryGirl.create(:session, { value: "xxx" })
        get :verify, {:session_id => invalid_session.key}
      end
      subject { JSON.parse(response.body) }

      its (["code"]) {should ==  "invalid_session"}
    end

    context '本日はじめてのログイン後の場合' do
      before do
        user = FactoryGirl.create(:user, {nickname: 'akira', point: 100, last_login_at: Time.local(2013,4,5,14,0,0)})
        session = FactoryGirl.create(:session, { value: user.id.to_s })
        Time.stub!(:now).and_return(Time.local(2013,4,6,14,0,0))

        get :verify, {:session_id => session.key}
      end
      subject { JSON.parse(response.body) }

      its (["login_bonus"]) {should ==  configatron.login_bonus}
    end

    context '二回目以降のログインの場合' do
      before do
        user = FactoryGirl.create(:user, {nickname: 'akira', point: 100, last_login_at: Time.local(2013,4,6,10,0,0)})
        session = FactoryGirl.create(:session, { value: user.id.to_s })
        Time.stub!(:now).and_return(Time.local(2013,4,6,14,0,0))
        Date.stub!(:today).and_return(Date.new(2013, 4, 6))

        get :verify, {:session_id => session.key}
      end
      subject { JSON.parse(response.body) }

      its (["login_bonus"]) {should ==  0}
    end
  end

  describe '#destroy' do
    context 'Sessionを破棄きできた時' do
      it do
        expect{
          post :destroy, {:session_id => @session.key}
        }.to change(Session, :count).by(-1)
      end
    end
      
    context 'Sessionを破棄きできた時' do
      before do
        get :destroy, {:session_id => @session.key}
      end
      subject { JSON.parse(response.body) }

      its (["status"]) {should ==  "ok"}
    end
  end

end