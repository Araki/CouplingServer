# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::FriendsController do
  before do
    @user = FactoryGirl.create(:user)
    @group = FactoryGirl.create(:group, {user_id: @user.id})
    @friend = FactoryGirl.create(:friend, {group_id: @group.id})
  end

  describe "GET 'index'" do
    it "assigns @friends" do
      get :index
      assigns(:friends).should eq([@friend])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET 'show'" do
    it "assigns @friend" do
      get 'show', {id: @friend.id}
      assigns(:friend).should eq(@friend)
    end

    it "renders the show template" do
      get 'show', {id: @friend.id}
      response.should render_template("show")
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', {id: @friend.id}
      response.should be_success
    end
  end

  describe 'PUT update' do
    before :each do
      @friend = FactoryGirl.create(:friend, nickname: "foo")
    end
    
    context "valid attributes" do
      it "located the requested @friend" do
        put :update, id: @friend, friend: FactoryGirl.attributes_for(:valid_friend)
        assigns(:friend).should eq(@friend)      
      end
    
      it "changes @friend's attributes" do
        put :update, id: @friend, 
          friend: FactoryGirl.attributes_for(:valid_friend, nickname: "bar")
        @friend.reload
        @friend.nickname.should eq("bar")
      end
    
      it "redirects to the updated friend" do
        put :update, id: @friend, friend: FactoryGirl.attributes_for(:valid_friend)
        response.should redirect_to [:admin, @user]
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @friend" do
        put :update, id: @friend, friend: FactoryGirl.attributes_for(:invalid_friend)
        assigns(:friend).should eq(@friend)      
      end
      
      it "does not change @friend's attributes" do
        put :update, id: @friend, 
          friend: FactoryGirl.attributes_for(:valid_friend, nickname: nil)
        @friend.reload
        @friend.nickname.should_not eq("bar")
      end
      
      it "re-renders the edit method" do
        put :update, id: @friend, friend: FactoryGirl.attributes_for(:invalid_friend)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the friend" do
      expect{
        delete :destroy, id: @friend        
      }.to change(Friend,:count).by(-1)
    end
      
    it "redirects to friends#index" do
      delete :destroy, id: @friend
      response.should redirect_to [:admin, @user]
    end  
  end
end
