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
        post :add, {amount: -44, session_id: @session.key}
      end

      it 'invalid_argumentsが返ること' do
        JSON.parse(response.body)['code'].should_not be_nil
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
        JSON.parse(response.body)['code'].should_not be_nil
      end
    end
  end
end