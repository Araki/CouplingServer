# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::ProfilesController do
  before do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, {user_id: @user.id, nickname: "foo"})
  end

  describe "GET 'index'" do
    it "assigns @profiles" do
      get :index
      assigns(:profiles).should eq([@profile])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET 'show'" do
    it "assigns @profile" do
      get 'show', {id: @profile.id}
      assigns(:profile).should eq(@profile)
    end

    it "renders the show template" do
      get 'show', {id: @profile.id}
      response.should render_template("show")
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', {id: @profile.id}
      response.should be_success
    end
  end

  describe 'PUT update' do
    context "valid attributes" do
      it "located the requested @profile" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:valid_profile)
        assigns(:profile).should eq(@profile)      
      end
    
      it "changes @profile's attributes" do
        put :update, id: @profile, 
          profile: {nickname: "bar"}
        @profile.reload
        @profile.nickname.should eq("bar")
      end
    
      it "redirects to the updated profile" do
        put :update, id: @profile, profile:  {nickname: "bar"}
        response.should redirect_to [:admin, @user]
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @profile" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:invalid_profile)
        assigns(:profile).should eq(@profile)      
      end
      
      it "does not change @profile's attributes" do
        put :update, id: @profile, 
          profile: FactoryGirl.attributes_for(:valid_profile, nickname: nil)
        @profile.reload
        @profile.nickname.should_not eq("bar")
      end
      
      it "re-renders the edit method" do
        put :update, id: @profile, profile: FactoryGirl.attributes_for(:invalid_profile)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the profile" do
      expect{
        delete :destroy, id: @profile        
      }.to change(Profile,:count).by(-1)
    end
      
    it "redirects to profiles#index" do
      delete :destroy, id: @profile
      response.should redirect_to [:admin, @user]
    end  
  end
end
