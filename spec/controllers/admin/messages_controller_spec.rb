# -*r coding: utf-8 -*-
require 'spec_helper'

describe Admin::MessagesController do
  before do
    profile = FactoryGirl.create(:profile)
    @user = FactoryGirl.create(:user)
    match = FactoryGirl.create(:match, {user_id: @user.id, profile_id: profile.id})
    @message = FactoryGirl.create(:message, {match_id: match.id, talk_key: match.talk_key})
  end

  describe "GET 'index'" do
    it "assigns @messages" do
      get :index, {user_id: @user.id } 
      assigns(:messages).should eq([@message])
    end

    it "renders the index template" do
      get :index, {user_id: @user.id } 
      response.should render_template("index")
    end
  end

  describe "DELETE 'destroy'" do
    it "deletes the message" do
      expect{
        delete :destroy, {id: @message, user_id: @user.id }      
      }.to change(Message,:count).by(-1)
    end
      
    it "redirects to messages#index" do
      delete :destroy, {id: @message, user_id: @user.id }  
      response.should redirect_to admin_user_messages_url(@user)
    end  
  end
end
