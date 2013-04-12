# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::GroupsController do
  before do
    @user = FactoryGirl.create(:user)
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  it 'ユーザーとグループを結びつけていないので'

  describe '#list' do
    before do
      10.times do |n|
        FactoryGirl.create(:group, {user_id: @user.id, head_count: 2})
      end
    end

    context 'グループが存在している場合' do
      before do
        get :list, {session_id: @session.key}
      end

      it 'お気に入りユーザーのリストが返ること' do
        # response.body.should ==  ''
        parsed_body = JSON.parse(response.body)
        parsed_body["current_page"].should == 1
        parsed_body["groups"].length.should == 10
        parsed_body["last_page"].should == true
        parsed_body["groups"][0]["head_count"].should == 2
      end
    end
  end

  describe '#create' do
    context '既にグループがあった場合' do
      before do
        @user2 = FactoryGirl.create(:user)
        group = FactoryGirl.create(:group, {user_id: @user2.id})
        @session2 = FactoryGirl.create(:session, { value: @user2.id.to_s })

        post :create, {session_id: @session2.key, group: FactoryGirl.attributes_for(:group)}
      end

      it 'internal_server_errorが返されること' do
        JSON.parse(response.body)["code"].should == "internal_server_error"
      end 
    end

    context '正常に作成された場合' do
      before do
        post :create, {session_id: @session.key, group: FactoryGirl.attributes_for(:group)}
      end

      it 'groupが返ること' do
        JSON.parse(response.body)["group"]["head_count"].should == 1
      end
    end

    context '正常に作成された場合2' do
      it 'お気に入りが作成されること' do
        expect{
          post :create, {session_id: @session.key, group: FactoryGirl.attributes_for(:group)}
        }.to change(Group, :count).by(1)
      end
    end

    context '正常に作成できなかった場合' do
      before do
        post :create, {session_id: @session.key, group: {head_count: 3}}
      end

      it 'エラーが返されること' do
        JSON.parse(response.body)["code"]["max_age"].should_not be_nil
      end 
    end

    context '正常に作成できなかった場合2' do
      it 'お気に入りが作成されないこと' do
        expect{
          post :create, {session_id: @session.key, group: {head_count: 3}}
        }.to change(Group, :count).by(0)
      end
    end
  end

  describe '#update' do
    context 'グループがなかった場合' do
      before do
        post :update, {session_id: @session.key, group: {head_count: 3}}
      end

      it 'internal_server_errorが返されること' do
        JSON.parse(response.body)["code"].should == "not_found"
      end 
    end

    context 'グループがあった場合' do
      before do
        @user2 = FactoryGirl.create(:user)
        group = FactoryGirl.create(:group, {user_id: @user2.id})
        @session2 = FactoryGirl.create(:session, { value: @user2.id.to_s })
      end

      context '正常に修正された場合' do
        before do
          post :update, {session_id: @session2.key, group:{head_count: 3}}
        end

        it 'internal_server_errorが返されること' do
          JSON.parse(response.body)["group"]["head_count"].should == 3
        end 
      end

      context '正常に修正できなかった場合' do
        before do
          post :update, {session_id: @session2.key, group:{head_count: nil}}
        end

        it 'internal_server_errorが返されること' do
          JSON.parse(response.body)["code"]["head_count"].should_not be_nil
        end 
      end    
    end
  end
end