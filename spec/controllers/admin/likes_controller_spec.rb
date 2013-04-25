# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::LikesController do
  before do
    @profile = FactoryGirl.create(:profile)
    @user = FactoryGirl.create(:user)
    @like = FactoryGirl.create(:like, {user_id: @user.id, profile_id: @profile.id})
  end

  describe "GET 'index'" do
    it "assigns @profiles" do
      get :index, {user_id: @user.id }  
      assigns(:profiles).should eq([@profile])
    end

    it "renders the index template" do
      get :index, {user_id: @user.id }  
      response.should render_template("index")
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the like" do
      expect{
        delete :destroy, {id: @profile.id, user_id: @user.id }     
      }.to change(Like,:count).by(-1)
    end
      
    it "redirects to likes#index" do
      delete :destroy, {id: @profile.id, user_id: @user.id }  
      response.should redirect_to admin_user_likes_url(@user)
    end  
  end
end
