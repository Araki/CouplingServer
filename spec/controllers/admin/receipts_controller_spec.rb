# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::ReceiptsController do
  before do
    FactoryGirl.create(:user)
    FactoryGirl.create(:item)
    @receipt = FactoryGirl.create(:receipt)
  end

  describe "GET 'index'" do
    it "assigns @receipts" do
      get :index
      assigns(:receipts).should eq([@receipt])
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET 'show'" do
    it "assigns @receipt" do
      get 'show', {id: @receipt.id}
      assigns(:receipt).should eq(@receipt)
    end

    it "renders the show template" do
      get 'show', {id: @receipt.id}
      response.should render_template("show")
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the receipt" do
      expect{
        delete :destroy, id: @receipt        
      }.to change(Receipt,:count).by(-1)
    end
      
    it "redirects to receipts#index" do
      delete :destroy, id: @receipt
      response.should redirect_to admin_receipts_url
    end  
  end
end
