# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::LikePointsController do
  include Helpers

  before do
    @user = FactoryGirl.create(:user, :point => 100)
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  describe "add" do
    it "add like ponts" do
      post :add, {amount: 5, session_id: @session.key}
    end
  end

  describe "consume" do
    it "consume like points" do
      post :consume, {amount: 5, session_id: @session.key}
    end
  end
end
