# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::MatchesController do
  before do
    @profile = FactoryGirl.create(:profile)
    @user = FactoryGirl.create(:user)
    @match = FactoryGirl.create(:match, {user_id: @user.id, profile_id: @profile.id})
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
    it "deletes the match" do
      expect{
        delete :destroy, {id: @profile.id, user_id: @user.id }
      }.to change(Match,:count).by(-1)
    end
      
    it "redirects to matches#index" do
      delete :destroy, {id: @profile.id, user_id: @user.id }
      response.should redirect_to  admin_user_matches_url(@user)
    end  
  end
end
