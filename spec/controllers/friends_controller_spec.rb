# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::FriendsController do
  before do
    @user = FactoryGirl.create(:user)
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  describe '#create' do
    context 'グループがなかった場合' do
      before do
        post :create, {session_id: @session.key, friend: {nickname: 'taro', age: 25}}
      end

      it 'internal_server_errorが返されること' do
        JSON.parse(response.body)["code"].should == "internal_server_error"
      end 
    end

    context 'グループがあった場合' do
      before do
        @group = FactoryGirl.create(:group, {user_id: @user.id})
      end

      context '正常に作成された場合' do
        before do
          post :create, {session_id: @session.key, friend: FactoryGirl.attributes_for(:friend)}
        end

        it 'friendが返ること' do
          JSON.parse(response.body)["friend"]["nickname"].should_not be_nil
        end
      end

      context '正常に作成された場合2' do
        it 'お友達が作成されること' do
          expect{
            post :create, {session_id: @session.key, friend: FactoryGirl.attributes_for(:friend)}
          }.to change(Friend, :count).by(1)
        end
      end

      context '正常に作成できなかった場合' do
        before do
          post :create, {session_id: @session.key, friend: {nickname: nil}}
        end

        it 'エラーが返されること' do
          JSON.parse(response.body)["code"]["nickname"].should_not be_nil
        end 
      end

      context '正常に作成できなかった場合2' do
        it 'お友達が作成されないこと' do
          expect{
            post :create, {session_id: @session.key, friend: {nickname: nil}}
          }.to change(Friend, :count).by(0)
        end
      end
    end
  end

  describe '#update' do
    context 'グループがなかった場合' do
      before do
        post :update, {session_id: @session.key, friend: {nickname: 'taro'}, id: 1}
      end

      it 'internal_server_errorが返されること' do
        JSON.parse(response.body)["code"].should == "not_found"
      end 
    end

    context 'グループがあった場合' do
      before do
        @group = FactoryGirl.create(:group, {user_id: @user.id})
      end

      context 'Friendがなかった場合' do
        before do
          post :update, {session_id: @session.key, friend: {nickname: 'taro'}, id: 1}
        end

        it 'not_foundが返されること' do
          JSON.parse(response.body)["code"].should == "not_found"
        end 
      end

      context 'Friendがあった場合' do
        context '自分のグループのFriendでなかった場合' do
          before do
            @friend = FactoryGirl.create(:friend, {group_id: 9999, nickname: 'donald'})
            post :update, {session_id: @session.key, friend: {nickname: 'taro'}, id: @friend.id}
          end

          it 'permission_deniedが返されること' do
            JSON.parse(response.body)["code"].should == "permission_denied"
          end 
        end

        context '自分のグループのFriendでなかった場合' do
          before do
            @friend = FactoryGirl.create(:friend, {group_id: @group.id, nickname: 'donald'})
          end

          context '正常に修正された場合' do
            before do
              post :update, {session_id: @session.key, friend: {nickname: 'taro'}, id: @friend.id}
            end

            it 'internal_server_errorが返されること' do
              JSON.parse(response.body)["friend"]["nickname"].should eq 'taro'
            end 
          end

          context '正常に修正できなかった場合' do
            before do
              post :update, {session_id: @session.key, friend: {nickname: nil}, id: @friend.id}
            end

            it 'internal_server_errorが返されること' do
              JSON.parse(response.body)["code"]["nickname"].should_not be_nil
            end 
          end
        end
      end
    end
  end
end