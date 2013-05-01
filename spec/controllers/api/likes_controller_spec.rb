# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::LikesController do
  include Helpers

  before do
    @user = FactoryGirl.create(:user)
    @target = FactoryGirl.create(:user)
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  describe '#list' do
    context 'いいねしたユーザーが見つかった場合' do
      before do
        10.times do
          target = FactoryGirl.create(:target)
          FactoryGirl.create(:profile, {user:  target})
          FactoryGirl.create(:like, {user: @user, target: target})
        end
      end

      context 'ユーザーのリストが返ること' do
        before do
          get :list, {session_id: @session.key}
        end

        it do
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

    context 'いいねをしてくれたユーザーが見つかった場合' do
      before do
        10.times do
          from_user = FactoryGirl.create(:user)
          FactoryGirl.create(:profile, {user:  from_user})
          FactoryGirl.create(:like, {user: from_user, target: @user})
        end
      end

      context 'いいねをしてくれたユーザーが見つかった場合' do
        before do
          get :list, {type: 'inverse', session_id: @session.key}
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
          get :list, {type: 'inverse', page: 2, per: 7, session_id: @session.key}
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

  describe '#create' do
    context '正常な値がPOSTされた場合' do
      context 'いいねが存在していないと' do
        it 'いいねが作成されること' do
          expect{
            post :create, {target_id: @target.id, session_id: @session.key}
          }.to change(Like, :count).by(1)
        end
      end

      context 'いいねが存在していないと2' do
        before do
          post :create, {target_id: @target.id, session_id: @session.key}
        end

        it 'likeが返されること' do
          JSON.parse(response.body)["type"].should == "like"
        end 
      end

      context '相手からのいいねが存在していると' do
        before do
          FactoryGirl.create(:like, {user: @target, target: @user})
        end

        context '相手からのいいねが存在していると' do
          it 'Matchが作成されること' do
            expect{
              post :create, {target_id: @target.id, session_id: @session.key}
            }.to change(Match, :count).by(2)
          end
        end

        context '相手からのいいねが存在していると2' do
          it 'Likeが減ることこと' do
            expect{
              post :create, {target_id: @target.id, session_id: @session.key}
            }.to change(Like, :count).by(-1)
          end
        end

        context '相手からのいいねが存在していると' do
          before do
            post :create, {target_id: @target.id, session_id: @session.key}
          end

          it 'matchが返されること' do
            JSON.parse(response.body)["type"].should == "match"
          end 
        end
      end

      context '作成に失敗すると' do
        before do
          user = session_verified_user(@session)
          invalid_user = FactoryGirl.build(:invalid_user)
          User.should_receive(:find_by_id).with(@user.id.to_s).and_return(user)
          User.should_receive(:find).with(@target.id.to_s).and_return(@target)
          user.should_receive(:over_likes_limit_per_day?).and_return(false)
          user.stub!(:create_like).with(@target).and_raise(ActiveRecord::RecordInvalid.new(invalid_user))          

          post :create, {target_id: @target.id, session_id: @session.key}
        end

        it 'internal_server_errorが返されること' do
          JSON.parse(response.body)["code"].should_not be_nil
        end 
      end

      context '当日の作成数の上限を超えていると' do
        before do
          user = session_verified_user(@session)
          target = mock('target')
          user.should_receive(:over_likes_limit_per_day?).and_return(true)
 
          post :create, {target_id: @target.id, session_id: @session.key}
        end

        it 'Limit Overが返されること' do
          JSON.parse(response.body)["code"].should == "Limit Over"
        end 
      end
    end

    context '相手が存在しない場合' do
      before do
        post :create, {target_id: 200, session_id: @session.key}
      end

      it 'not_foundが返されること' do
        JSON.parse(response.body)["code"].should include "Couldn't find User with id="
      end 
    end
  end
end