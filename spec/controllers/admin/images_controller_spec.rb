# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::ImagesController do
  before do
    FactoryGirl.create(:user)
    FactoryGirl.create(:profile)
    @image = FactoryGirl.create(:image)
  end

  describe "GET 'index'" do
    it "assigns @images" do
      get :index
      assigns(:images).should eq([@image])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET 'show'" do
    it "assigns @image" do
      get 'show', {id: @image.id}
      assigns(:image).should eq(@image)
    end

    it "renders the show template" do
      get 'show', {id: @image.id}
      response.should render_template("show")
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the image" do
      expect{
        delete :destroy, id: @image        
      }.to change(Image,:count).by(-1)
    end
      
    it "redirects to images#index" do
      delete :destroy, id: @image
      response.should redirect_to admin_images_url
    end  
  end
end
