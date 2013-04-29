# -*r coding: utf-8 -*-
require 'spec_helper'

describe Like do
  before do
    @user = FactoryGirl.create(:user)
    @target = FactoryGirl.create(:target)

    @like =  FactoryGirl.create(:like, {user_id: @user.id, target_id: @target.id})
    @inverse_like =  FactoryGirl.create(:like, {user_id: @target.id, target_id: @user.id}) 
  end

  describe "#inverse" do
    context '対となるlikeを返すこと' do
      subject { @inverse_like.inverse }

      it { should eq @like }
    end
    context '対となるlikeを返すこと2' do
      subject { @like.inverse }

      it { should eq @inverse_like }
    end
  end
end