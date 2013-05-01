# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::GroupImagesController do
  before do
    @group_image = FactoryGirl.create(:group_image)
  end

  describe "GET 'index'" do
    it "assigns @group_images" do
      get :index
      assigns(:group_images).should eq([@group_image])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET 'show'" do
    it "assigns @group_image" do
      get 'show', {id: @group_image.id}
      assigns(:group_image).should eq(@group_image)
    end

    it "renders the show template" do
      get 'show', {id: @group_image.id}
      response.should render_template("show")
    end
  end

  describe "GET 'new'" do
    it "assigns @group_image" do
      get 'new'
      assigns(:group_image).should be_a_new(GroupImage)
    end

    it "renders the new template" do
      get 'new'
      response.should render_template("new")
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new group_image" do
        expect{
          post :create, group_image: FactoryGirl.attributes_for(:group_image)
        }.to change(GroupImage,:count).by(1)
      end
      
      it "redirects to the new group_image" do
        post :create, group_image: FactoryGirl.attributes_for(:group_image)
        response.should redirect_to [:admin, GroupImage.last]
      end
    end
    
    context "with invalid attributes" do
      it "does not save the new group_image" do
        expect{
          post :create, group_image: FactoryGirl.attributes_for(:invalid_group_image)
        }.to_not change(GroupImage,:count)
      end
      
      it "re-renders the new method" do
        post :create, group_image: FactoryGirl.attributes_for(:invalid_group_image)
        response.should render_template :new
      end
    end 
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', {id: @group_image.id}
      response.should be_success
    end
  end

  describe 'PUT update' do
    before :each do
      @group_image = FactoryGirl.create(:group_image, name: "Lawrence")
    end
    
    context "valid attributes" do
      it "located the requested @group_image" do
        put :update, id: @group_image, group_image: FactoryGirl.attributes_for(:group_image)
        assigns(:group_image).should eq(@group_image)      
      end
    
      it "changes @group_image's attributes" do
        put :update, id: @group_image, 
          group_image: FactoryGirl.attributes_for(:group_image, name: "Larry")
        @group_image.reload
        @group_image.name.should eq("Larry")
      end
    
      it "redirects to the updated group_image" do
        put :update, id: @group_image, group_image: FactoryGirl.attributes_for(:group_image)
        response.should redirect_to [:admin, @group_image]
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @group_image" do
        put :update, id: @group_image, group_image: FactoryGirl.attributes_for(:invalid_group_image)
        assigns(:group_image).should eq(@group_image)      
      end
      
      it "does not change @group_image's attributes" do
        put :update, id: @group_image, 
          group_image: FactoryGirl.attributes_for(:group_image, name: nil)
        @group_image.reload
        @group_image.name.should_not eq("Larry")
      end
      
      it "re-renders the edit method" do
        put :update, id: @group_image, group_image: FactoryGirl.attributes_for(:invalid_group_image)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the group_image" do
      expect{
        delete :destroy, id: @group_image        
      }.to change(GroupImage,:count).by(-1)
    end
      
    it "redirects to group_images#index" do
      delete :destroy, id: @group_image
      response.should redirect_to admin_group_images_url
    end  
  end
end
