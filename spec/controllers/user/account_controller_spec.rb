# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::User::AccountController do
  before do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, {user_id: @user.id})
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  describe '#show_profile' do
    context '自分のアカウントが見つかった場合' do
      before do
        get :show_profile, {:session_id => @session.key}
      end
      subject { JSON.parse(response.body)["user"]["profile"] }

      its (["nickname"]) {should ==  @profile.nickname  }
    end

    context '自分のアカウントが見つからなかった場合' do
      before do
        invalid_session = FactoryGirl.create(:session, { value: "xxx" })
        get :show_profile, {:session_id => invalid_session.key}
      end
      subject { JSON.parse(response.body)["code"] }

      it { should ==  "invalid_session"  }
    end
  end

  describe '#update_profile' do
    context '正常な値をPOSTしたら' do
      before do
        post :update_profile, {user: {profile: {nickname: 'koro'}}, session_id: @session.key}
      end
      subject { JSON.parse(response.body)["user"]["profile"] }

      its (["nickname"]) {should == 'koro' }
    end

    context 'ユーザーからは変更できない値をPOSTした場合' do
      before do
        post :update_profile, {user: {profile: {gender: 1}}, session_id: @session.key}
      end
      subject { JSON.parse(response.body)["code"] }

      it {should == "Can't mass-assign protected attributes: gender" }
    end

    context 'invalidな値をPOSTしたら' do
      it 'エラーが返ること' 
      before do
        # mock = mock_model(User)
        # mock.errors.stub!(:full_messages).and_return([])        
        # error = ActiveRecord::RecordInvalid.new(mock)
        # mock.stub!(:save).and_raise(error)
        # mock.stub!(:nickname=).with("100")
        # User.stub!(:find_by_id).with(@user.id.to_s).and_return(mock)  

        post :update_profile, {user: {profile: {height: '高い'}}, session_id: @session.key}
      end
      subject { JSON.parse(response.body) }

      its (["status"]) {should == 'ng' }
      its (["code"]) {should == "Validation failed: Height is not included in the list, Height is not included in the list" }
    end
  end

  describe '#destroy' do
    context 'アカウントの削除の場合' do
      before do
        post :destroy, {session_id: @session.key}
      end
      subject { JSON.parse(response.body)["status"] }

      it {should == 'ok' }
    end

    context 'ユーザーが一つ減ること' do
      it do
        expect{
          post :destroy, {session_id: @session.key}
        }.to change(User, :count).by(-1)
      end
    end
  end  
end