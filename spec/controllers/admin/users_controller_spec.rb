# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::UsersController do
  before do
    @user = FactoryGirl.create(:user)
  end

  describe "GET 'index'" do
    it "assigns @users" do
      get :index
      assigns(:users).should eq([@user])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET 'show'" do
    it "assigns @user" do
      get 'show', {id: @user.id}
      assigns(:user).should eq(@user)
    end

    it "renders the show template" do
      get 'show', {id: @user.id}
      response.should render_template("show")
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', {id: @user.id}
      response.should be_success
    end
  end

  describe 'PUT update' do
    before :each do
      @user = FactoryGirl.create(:user, email: "foo@example.com")
    end
    
    context "valid attributes" do
      it "located the requested @user" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:valid_user)
        assigns(:user).should eq(@user)      
      end
    
      it "changes @user's attributes" do
        put :update, id: @user, 
          user: FactoryGirl.attributes_for(:valid_user, email: "bar@example.com")
        @user.reload
        @user.email.should eq("bar@example.com")
      end
    
      it "redirects to the updated user" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:valid_user)
        response.should redirect_to [:admin, @user]
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @user" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:invalid_user)
        assigns(:user).should eq(@user)      
      end
      
      it "does not change @user's attributes" do
        put :update, id: @user, 
          user: FactoryGirl.attributes_for(:valid_user, email: nil)
        @user.reload
        @user.email.should_not eq("bar@example.com")
      end
      
      it "re-renders the edit method" do
        put :update, id: @user, user: FactoryGirl.attributes_for(:invalid_user)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the user" do
      expect{
        delete :destroy, id: @user        
      }.to change(User,:count).by(-1)
    end
      
    it "redirects to users#index" do
      delete :destroy, id: @user
      response.should redirect_to admin_users_url
    end  
  end
end
