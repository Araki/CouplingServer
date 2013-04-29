# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::PointsController do
  include Helpers

  before do
    @user = FactoryGirl.create(:user, :point => 100)
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })

    @target = FactoryGirl.create(:user)
  end

  describe '#add' do

    context '正常な値を送った場合' do
      before do
        post :add, {amount: 5, session_id: @session.key}
      end

      it 'Pointがamount分追加されること' do
        JSON.parse(response.body)["user"]["point"].should == 105
      end
    end

    context '不正な値だった場合' do
      before do
        user = session_verified_user(@session)
        user.should_receive(:errors).and_return({base: ["invalid_arguments"]})
        user.should_receive(:add_point).with(-44).and_return(false)

        post :add, {amount: -44, session_id: @session.key}
      end

      it 'invalid_argumentsが返ること' do
        JSON.parse(response.body)['code']["base"][0].should == 'invalid_arguments'
      end
    end

  end

  describe '#consume' do

    context '正常な値を送った場合' do
      before do
        post :consume, {amount: 5, session_id: @session.key}
      end

      it 'Pointがamount分引かれること'  do
        JSON.parse(response.body)["user"]["point"].should == 95
      end
    end

    context '持ちポイント以上を使おうとした場合' do
      before do
        post :consume, {amount: 1000, session_id: @session.key}
      end

      it 'invalid_argumentsが返ること' do
        JSON.parse(response.body)['code']["base"][0].should == 'invalid_arguments'
      end
    end

    context '保存に失敗した場合' do
      before do
        user = session_verified_user(@session)
        user.should_receive(:errors).and_return({base: ["internal_server_error"]})
        user.should_receive(:consume_point).with(99).and_return(false)

        post :consume, {amount: 99, session_id: @session.key}
      end

      it 'internal_server_errorが返ること' do
        JSON.parse(response.body)['code']["base"][0].should == 'internal_server_error'
      end
    end
  end
end