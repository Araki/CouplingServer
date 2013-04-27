# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::GroupsController do
  before do
    @user = FactoryGirl.create(:user)
    @group = FactoryGirl.create(:group, {user_id: @user.id, head_count: 2})
  end

  describe "GET 'index'" do
    it "assigns @groups" do
      get :index
      assigns(:groups).should eq([@group])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET 'show'" do
    it "assigns @group" do
      get 'show', {id: @group.id}
      assigns(:group).should eq(@group)
    end

    it "renders the show template" do
      get 'show', {id: @group.id}
      response.should render_template("show")
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', {id: @group.id}
      response.should be_success
    end
  end

  describe 'PUT update' do    
    context "valid attributes" do
      it "located the requested @group" do
        put :update, id: @group, group: FactoryGirl.attributes_for(:group)
        assigns(:group).should eq(@group)      
      end
    
      it "changes @group's attributes" do
        put :update, id: @group, 
          group: FactoryGirl.attributes_for(:group, head_count: 2)
        @group.reload
        @group.head_count.should eq(2)
      end
    
      it "redirects to the updated group" do
        put :update, id: @group, group: FactoryGirl.attributes_for(:group)
        response.should redirect_to [:admin, @user]
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @group" do
        put :update, id: @group, group: FactoryGirl.attributes_for(:invalid_group)
        assigns(:group).should eq(@group)      
      end
      
      it "does not change @group's attributes" do
        put :update, id: @group, 
          group: FactoryGirl.attributes_for(:group, head_count: nil)
        @group.reload
        @group.head_count.should eq(2)
      end
      
      it "re-renders the edit method" do
        put :update, id: @group, group: FactoryGirl.attributes_for(:invalid_group)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the group" do
      expect{
        delete :destroy, id: @group        
      }.to change(Group,:count).by(-1)
    end
      
    it "redirects to groups#index" do
      delete :destroy, id: @group
      response.should redirect_to [:admin, @user]
    end  
  end
end
