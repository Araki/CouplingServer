# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::CharactersController do
  before do
    @character = FactoryGirl.create(:character)
  end

  describe "GET 'index'" do
    it "assigns @characters" do
      get :index
      assigns(:characters).should eq([@character])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET 'show'" do
    it "assigns @character" do
      get 'show', {id: @character.id}
      assigns(:character).should eq(@character)
    end

    it "renders the show template" do
      get 'show', {id: @character.id}
      response.should render_template("show")
    end
  end

  describe "GET 'new'" do
    it "assigns @character" do
      get 'new'
      assigns(:character).should be_a_new(Character)
    end

    it "renders the new template" do
      get 'new'
      response.should render_template("new")
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new character" do
        expect{
          post :create, character: FactoryGirl.attributes_for(:character)
        }.to change(Character,:count).by(1)
      end
      
      it "redirects to the new character" do
        post :create, character: FactoryGirl.attributes_for(:character)
        response.should redirect_to [:admin, Character.last]
      end
    end
    
    context "with invalid attributes" do
      it "does not save the new character" do
        expect{
          post :create, character: FactoryGirl.attributes_for(:invalid_character)
        }.to_not change(Character,:count)
      end
      
      it "re-renders the new method" do
        post :create, character: FactoryGirl.attributes_for(:invalid_character)
        response.should render_template :new
      end
    end 
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit', {id: @character.id}
      response.should be_success
    end
  end

  describe 'PUT update' do
    before :each do
      @character = FactoryGirl.create(:character, name: "Lawrence")
    end
    
    context "valid attributes" do
      it "located the requested @character" do
        put :update, id: @character, character: FactoryGirl.attributes_for(:character)
        assigns(:character).should eq(@character)      
      end
    
      it "changes @character's attributes" do
        put :update, id: @character, 
          character: FactoryGirl.attributes_for(:character, name: "Larry")
        @character.reload
        @character.name.should eq("Larry")
      end
    
      it "redirects to the updated character" do
        put :update, id: @character, character: FactoryGirl.attributes_for(:character)
        response.should redirect_to [:admin, @character]
      end
    end
    
    context "invalid attributes" do
      it "locates the requested @character" do
        put :update, id: @character, character: FactoryGirl.attributes_for(:invalid_character)
        assigns(:character).should eq(@character)      
      end
      
      it "does not change @character's attributes" do
        put :update, id: @character, 
          character: FactoryGirl.attributes_for(:character, name: nil)
        @character.reload
        @character.name.should_not eq("Larry")
      end
      
      it "re-renders the edit method" do
        put :update, id: @character, character: FactoryGirl.attributes_for(:invalid_character)
        response.should render_template :edit
      end
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the character" do
      expect{
        delete :destroy, id: @character        
      }.to change(Character,:count).by(-1)
    end
      
    it "redirects to characters#index" do
      delete :destroy, id: @character
      response.should redirect_to admin_characters_url
    end  
  end
end
