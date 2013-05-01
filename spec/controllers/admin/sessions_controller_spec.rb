# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::SessionsController do
  before do
    @user = FactoryGirl.create(:user)
    @session = FactoryGirl.create(:session)
  end

  describe "GET 'index'" do
    it "assigns @sessions" do
      get :index
      assigns(:sessions).should eq([@session])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET 'show'" do
    it "assigns @session" do
      get 'show', {id: @session.id}
      assigns(:session).should eq(@session)
    end

    it "renders the show template" do
      get 'show', {id: @session.id}
      response.should render_template("show")
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new session" do
        expect{
          post :create, session: FactoryGirl.attributes_for(:session)
        }.to change(Session,:count).by(1)
      end
      
      it "redirects to the new session" do
        post :create, session: FactoryGirl.attributes_for(:session)
        response.should redirect_to [:admin, Session.last]
      end
    end
    
    context "with invalid attributes" do
      it "does not save the new session" do
        expect{
          post :create, session: FactoryGirl.attributes_for(:invalid_session)
        }.to_not change(Session,:count)
      end
      
      it "re-renders the new method" do
        post :create, session: FactoryGirl.attributes_for(:invalid_session)
        response.should render_template :new
      end
    end 
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', {id: @session.id}
      response.should be_success
    end
  end

  describe 'PUT update' do
    before :each do
      @session = FactoryGirl.create(:session, key: "Lawrence")
    end
    
    context "valid attributes" do
      it "located the requested @session" do
        put :update, id: @session, session: FactoryGirl.attributes_for(:session)
        assigns(:session).should eq(@session)      
      end
    
      it "changes @session's attributes" do
        put :update, id: @session, 
          session: FactoryGirl.attributes_for(:session, key: "Larry")
        @session.reload
        @session.key.should eq("Larry")
      end
    
      it "redirects to the updated session" do
        put :update, id: @session, session: FactoryGirl.attributes_for(:session)
        response.should redirect_to [:admin, @session]
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @session" do
        put :update, id: @session, session: FactoryGirl.attributes_for(:invalid_session)
        assigns(:session).should eq(@session)      
      end
      
      it "does not change @session's attributes" do
        put :update, id: @session, 
          session: FactoryGirl.attributes_for(:session, key: nil)
        @session.reload
        @session.key.should_not eq("Larry")
      end
      
      it "re-renders the edit method" do
        put :update, id: @session, session: FactoryGirl.attributes_for(:invalid_session)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the session" do
      expect{
        delete :destroy, id: @session        
      }.to change(Session,:count).by(-1)
    end
      
    it "redirects to sessions#index" do
      delete :destroy, id: @session
      response.should redirect_to admin_sessions_url
    end  
  end
end
