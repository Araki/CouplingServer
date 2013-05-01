# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::FavoritesController do
  before do
    @target = FactoryGirl.create(:target)
    @user = FactoryGirl.create(:user)
    @favorite = FactoryGirl.create(:favorite, {user: @user, target: @target})
  end

  describe "GET 'index'" do
    it "assigns @targets" do
      get :index, {user_id: @user.id }
      assigns(:users).should eq([@target])
    end

    it "renders the index template" do
      get :index, {user_id: @user.id }
      response.should render_template("index")
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the favorite" do
      expect{
        delete :destroy, {id: @target.id, user_id: @user.id }   
      }.to change(Favorite,:count).by(-1)
    end
      
    it "redirects to favorites#index" do
      delete :destroy, {id: @target.id, user_id: @user.id }  
      response.should redirect_to admin_user_favorites_url(@user)
    end  
  end
end
