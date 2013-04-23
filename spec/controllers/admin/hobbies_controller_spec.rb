# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::HobbiesController do
  before do
    @hobby = FactoryGirl.create(:hobby)
  end

  describe "GET 'index'" do
    it "assigns @hobbies" do
      get :index
      assigns(:hobbies).should eq([@hobby])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET 'show'" do
    it "assigns @hobby" do
      get 'show', {id: @hobby.id}
      assigns(:hobby).should eq(@hobby)
    end

    it "renders the show template" do
      get 'show', {id: @hobby.id}
      response.should render_template("show")
    end
  end

  describe "GET 'new'" do
    it "assigns @hobby" do
      get 'new'
      assigns(:hobby).should be_a_new(Hobby)
    end

    it "renders the new template" do
      get 'new'
      response.should render_template("new")
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new hobby" do
        expect{
          post :create, hobby: FactoryGirl.attributes_for(:hobby)
        }.to change(Hobby,:count).by(1)
      end
      
      it "redirects to the new hobby" do
        post :create, hobby: FactoryGirl.attributes_for(:hobby)
        response.should redirect_to [:admin, Hobby.last]
      end
    end
    
    context "with invalid attributes" do
      it "does not save the new hobby" do
        expect{
          post :create, hobby: FactoryGirl.attributes_for(:invalid_hobby)
        }.to_not change(Hobby,:count)
      end
      
      it "re-renders the new method" do
        post :create, hobby: FactoryGirl.attributes_for(:invalid_hobby)
        response.should render_template :new
      end
    end 
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', {id: @hobby.id}
      response.should be_success
    end
  end

  describe 'PUT update' do
    before :each do
      @hobby = FactoryGirl.create(:hobby, name: "Lawrence")
    end
    
    context "valid attributes" do
      it "located the requested @hobby" do
        put :update, id: @hobby, hobby: FactoryGirl.attributes_for(:hobby)
        assigns(:hobby).should eq(@hobby)      
      end
    
      it "changes @hobby's attributes" do
        put :update, id: @hobby, 
          hobby: FactoryGirl.attributes_for(:hobby, name: "Larry")
        @hobby.reload
        @hobby.name.should eq("Larry")
      end
    
      it "redirects to the updated hobby" do
        put :update, id: @hobby, hobby: FactoryGirl.attributes_for(:hobby)
        response.should redirect_to [:admin, @hobby]
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @hobby" do
        put :update, id: @hobby, hobby: FactoryGirl.attributes_for(:invalid_hobby)
        assigns(:hobby).should eq(@hobby)      
      end
      
      it "does not change @hobby's attributes" do
        put :update, id: @hobby, 
          hobby: FactoryGirl.attributes_for(:hobby, name: nil)
        @hobby.reload
        @hobby.name.should_not eq("Larry")
      end
      
      it "re-renders the edit method" do
        put :update, id: @hobby, hobby: FactoryGirl.attributes_for(:invalid_hobby)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the hobby" do
      expect{
        delete :destroy, id: @hobby        
      }.to change(Hobby,:count).by(-1)
    end
      
    it "redirects to hobbies#index" do
      delete :destroy, id: @hobby
      response.should redirect_to admin_hobbies_url
    end  
  end
end
