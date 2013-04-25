# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::GroupsController do
  before do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, {user_id: @user.id, gender:0})
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  describe '#show' do
    before do
      group = FactoryGirl.create(:group, {user_id: @user.id, head_count: 3})
      group.friends = FactoryGirl.create_list(:friend, 3)
      group.save
    end

    context 'グループが存在している場合' do
      before do
        get :show, {session_id: @session.key}
      end

      it 'グループが返ること' do
        parsed_body = JSON.parse(response.body)
        parsed_body["group"]["head_count"].should == 3
        parsed_body["group"]["friends"].count.should == 3
        parsed_body["group"]["leader"][:user_id] == @user.id
      end
    end
  end

  describe '#list' do
    before do
      10.times do |n|
        user = FactoryGirl.create(:user)
        FactoryGirl.create(:male_profile, {user_id: user.id})
        group = FactoryGirl.create(:group, {user_id: user.id, head_count: 2})
        group.friends = FactoryGirl.create_list(:friend, 3)
        group.save
      end
    end

    context '検索結果が存在している場合' do
      before do
        get :list, {session_id: @session.key}
      end

      it 'グループのリストが返ること' do
        # response.body.should ==  ''
        parsed_body = JSON.parse(response.body)
        parsed_body["current_page"].should == 1
        parsed_body["groups"].length.should == 10
        parsed_body["last_page"].should == true
        parsed_body["groups"][0]["head_count"].should == 2
        parsed_body["groups"][0]["friends"].count.should == 3
        parsed_body["groups"][0]["leader"].should_not be_nil
      end
    end
  end

  describe '#search' do
    before do
      10.times do |n|
        user = FactoryGirl.create(:user)
        FactoryGirl.create(:female_profile, {user_id: user.id})
        group = FactoryGirl.create(:group, {user_id: user.id, head_count: 2, gender: 1})
        group.friends = FactoryGirl.create_list(:friend, 3)
        group.save
      end
    end

    context 'グループが存在している場合' do
      before do
        get :search, {session_id: @session.key}
      end

      it 'グループのリストが返ること' do
        # response.body.should ==  ''
        parsed_body = JSON.parse(response.body)
        parsed_body["current_page"].should == 1
        parsed_body["groups"].length.should == 10
        parsed_body["last_page"].should == true
        parsed_body["groups"][0]["head_count"].should == 2
        parsed_body["groups"][0]["friends"].count.should == 3
        parsed_body["groups"][0]["leader"].should_not be_nil
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
        JSON.parse(response.body)["group"]["head_count"].should_not be_nil
      end
    end

    context '正常に作成された場合2' do
      it 'お気に入りが作成されること' do
        expect{
          post :create, {session_id: @session.key, group: FactoryGirl.attributes_for(:group)}
        }.to change(Group, :count).by(1)
      end
    end

    context '複数選択項目も作成されること' do
      before do
        group_images = FactoryGirl.create_list(:group_image, 10)
        post :create, {
          group: FactoryGirl.attributes_for(:group),
          group_images: [group_images[0].id,group_images[1].id,group_images[2].id], session_id: @session.key
        }
      end
      subject { JSON.parse(response.body)["group"]["group_images"] }

      its (:length) {should == 3 }
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

      context '複数選択項目も修正されること' do
        before do
          group_images = FactoryGirl.create_list(:group_image, 10)
          post :update, {group: {}, group_images: [group_images[0].id,group_images[1].id,group_images[2].id], session_id: @session2.key}
        end
        subject { JSON.parse(response.body)["group"]["group_images"] }

        its (:length) {should == 3 }
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