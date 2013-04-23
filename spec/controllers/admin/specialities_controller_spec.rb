# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::SpecialitiesController do
  before do
    @speciality = FactoryGirl.create(:speciality)
  end

  describe "GET 'index'" do
    it "assigns @specialities" do
      get :index
      assigns(:specialities).should eq([@speciality])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET 'show'" do
    it "assigns @speciality" do
      get 'show', {id: @speciality.id}
      assigns(:speciality).should eq(@speciality)
    end

    it "renders the show template" do
      get 'show', {id: @speciality.id}
      response.should render_template("show")
    end
  end

  describe "GET 'new'" do
    it "assigns @speciality" do
      get 'new'
      assigns(:speciality).should be_a_new(Speciality)
    end

    it "renders the new template" do
      get 'new'
      response.should render_template("new")
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new speciality" do
        expect{
          post :create, speciality: FactoryGirl.attributes_for(:speciality)
        }.to change(Speciality,:count).by(1)
      end
      
      it "redirects to the new speciality" do
        post :create, speciality: FactoryGirl.attributes_for(:speciality)
        response.should redirect_to [:admin, Speciality.last]
      end
    end
    
    context "with invalid attributes" do
      it "does not save the new speciality" do
        expect{
          post :create, speciality: FactoryGirl.attributes_for(:invalid_speciality)
        }.to_not change(Speciality,:count)
      end
      
      it "re-renders the new method" do
        post :create, speciality: FactoryGirl.attributes_for(:invalid_speciality)
        response.should render_template :new
      end
    end 
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', {id: @speciality.id}
      response.should be_success
    end
  end

  describe 'PUT update' do
    before :each do
      @speciality = FactoryGirl.create(:speciality, name: "Lawrence")
    end
    
    context "valid attributes" do
      it "located the requested @speciality" do
        put :update, id: @speciality, speciality: FactoryGirl.attributes_for(:speciality)
        assigns(:speciality).should eq(@speciality)      
      end
    
      it "changes @speciality's attributes" do
        put :update, id: @speciality, 
          speciality: FactoryGirl.attributes_for(:speciality, name: "Larry")
        @speciality.reload
        @speciality.name.should eq("Larry")
      end
    
      it "redirects to the updated speciality" do
        put :update, id: @speciality, speciality: FactoryGirl.attributes_for(:speciality)
        response.should redirect_to [:admin, @speciality]
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @speciality" do
        put :update, id: @speciality, speciality: FactoryGirl.attributes_for(:invalid_speciality)
        assigns(:speciality).should eq(@speciality)      
      end
      
      it "does not change @speciality's attributes" do
        put :update, id: @speciality, 
          speciality: FactoryGirl.attributes_for(:speciality, name: nil)
        @speciality.reload
        @speciality.name.should_not eq("Larry")
      end
      
      it "re-renders the edit method" do
        put :update, id: @speciality, speciality: FactoryGirl.attributes_for(:invalid_speciality)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the speciality" do
      expect{
        delete :destroy, id: @speciality        
      }.to change(Speciality,:count).by(-1)
    end
      
    it "redirects to specialities#index" do
      delete :destroy, id: @speciality
      response.should redirect_to admin_specialities_url
    end  
  end
end
