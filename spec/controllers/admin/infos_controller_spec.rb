# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::InfosController do
  before do
    FactoryGirl.create(:user)
    @info = FactoryGirl.create(:info)
  end

  describe "GET 'index'" do
    it "assigns @infos" do
      get :index
      assigns(:infos).should eq([@info])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET 'show'" do
    it "assigns @info" do
      get 'show', {id: @info.id}
      assigns(:info).should eq(@info)
    end

    it "renders the show template" do
      get 'show', {id: @info.id}
      response.should render_template("show")
    end
  end

  describe "GET 'new'" do
    it "assigns @info" do
      get 'new'
      assigns(:info).should be_a_new(Info)
    end

    it "renders the new template" do
      get 'new'
      response.should render_template("new")
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new info" do
        expect{
          post :create, info: FactoryGirl.attributes_for(:info)
        }.to change(Info,:count).by(1)
      end
      
      it "redirects to the new info" do
        post :create, info: FactoryGirl.attributes_for(:info)
        response.should redirect_to [:admin, Info.last]
      end
    end
    
    context "with invalid attributes" do
      it "does not save the new info" do
        expect{
          post :create, info: FactoryGirl.attributes_for(:invalid_info)
        }.to_not change(Info,:count)
      end
      
      it "re-renders the new method" do
        post :create, info: FactoryGirl.attributes_for(:invalid_info)
        response.should render_template :new
      end
    end 
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', {id: @info.id}
      response.should be_success
    end
  end

  describe 'PUT update' do
    before :each do
      @info = FactoryGirl.create(:info, body: "Lawrence")
    end
    
    context "valid attributes" do
      it "located the requested @info" do
        put :update, id: @info, info: FactoryGirl.attributes_for(:info)
        assigns(:info).should eq(@info)      
      end
    
      it "changes @info's attributes" do
        put :update, id: @info, 
          info: FactoryGirl.attributes_for(:info, body: "Larry")
        @info.reload
        @info.body.should eq("Larry")
      end
    
      it "redirects to the updated info" do
        put :update, id: @info, info: FactoryGirl.attributes_for(:info)
        response.should redirect_to [:admin, @info]
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @info" do
        put :update, id: @info, info: FactoryGirl.attributes_for(:invalid_info)
        assigns(:info).should eq(@info)      
      end
      
      it "does not change @info's attributes" do
        put :update, id: @info, 
          info: FactoryGirl.attributes_for(:info, body: nil)
        @info.reload
        @info.body.should_not eq("Larry")
      end
      
      it "re-renders the edit method" do
        put :update, id: @info, info: FactoryGirl.attributes_for(:invalid_info)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the info" do
      expect{
        delete :destroy, id: @info        
      }.to change(Info,:count).by(-1)
    end
      
    it "redirects to infos#index" do
      delete :destroy, id: @info
      response.should redirect_to admin_infos_url
    end  
  end
end
