# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::ItemsController do
  before do
    @item = FactoryGirl.create(:item)
  end

  describe "GET 'index'" do
    it "assigns @items" do
      get :index
      assigns(:items).should eq([@item])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET 'show'" do
    it "assigns @item" do
      get 'show', {id: @item.id}
      assigns(:item).should eq(@item)
    end

    it "renders the show template" do
      get 'show', {id: @item.id}
      response.should render_template("show")
    end
  end

  describe "GET 'new'" do
    it "assigns @item" do
      get 'new'
      assigns(:item).should be_a_new(Item)
    end

    it "renders the new template" do
      get 'new'
      response.should render_template("new")
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new item" do
        expect{
          post :create, item: FactoryGirl.attributes_for(:item)
        }.to change(Item,:count).by(1)
      end
      
      it "redirects to the new item" do
        post :create, item: FactoryGirl.attributes_for(:item)
        response.should redirect_to [:admin, Item.last]
      end
    end
    
    context "with invalid attributes" do
      it "does not save the new item" do
        expect{
          post :create, item: FactoryGirl.attributes_for(:invalid_item)
        }.to_not change(Item,:count)
      end
      
      it "re-renders the new method" do
        post :create, item: FactoryGirl.attributes_for(:invalid_item)
        response.should render_template :new
      end
    end 
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', {id: @item.id}
      response.should be_success
    end
  end

  describe 'PUT update' do
    before :each do
      @item = FactoryGirl.create(:item, title: "Lawrence")
    end
    
    context "valid attributes" do
      it "located the requested @item" do
        put :update, id: @item, item: FactoryGirl.attributes_for(:item)
        assigns(:item).should eq(@item)      
      end
    
      it "changes @item's attributes" do
        put :update, id: @item, 
          item: FactoryGirl.attributes_for(:item, title: "Larry")
        @item.reload
        @item.title.should eq("Larry")
      end
    
      it "redirects to the updated item" do
        put :update, id: @item, item: FactoryGirl.attributes_for(:item)
        response.should redirect_to [:admin, @item]
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @item" do
        put :update, id: @item, item: FactoryGirl.attributes_for(:invalid_item)
        assigns(:item).should eq(@item)      
      end
      
      it "does not change @item's attributes" do
        put :update, id: @item, 
          item: FactoryGirl.attributes_for(:item, title: nil)
        @item.reload
        @item.title.should_not eq("Larry")
      end
      
      it "re-renders the edit method" do
        put :update, id: @item, item: FactoryGirl.attributes_for(:invalid_item)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the item" do
      expect{
        delete :destroy, id: @item        
      }.to change(Item,:count).by(-1)
    end
      
    it "redirects to items#index" do
      delete :destroy, id: @item
      response.should redirect_to admin_items_url
    end  
  end
end
