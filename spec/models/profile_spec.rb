# -*r coding: utf-8 -*-
require 'spec_helper'

describe Profile do
  before do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, {user_id: @user.id})
  end

  describe "#assign_fb_attributes" do
    before do
      @fb_profile = {
        id: '1234567890',
        email: 'test@example.com',
        first_name: "First", 
        last_name: "Last", 
        gender: "male",
        birthday: 28.years.ago.strftime("%m/%d/%Y")
      }
    end

    context '作成できたら' do
      let(:profile) { Profile.new() }
      subject { profile.send(:assign_fb_attributes, @user, @fb_profile) }

      its (:gender) { should eq 0 }
      its (:nickname) { should eq 'F.L' }
      its (:age) { should eq 28 }
    end

    context '既存のユーザーの場合' do
      let(:profile) { FactoryGirl.create(:profile, {gender: 1}) }
      subject { profile.send(:assign_fb_attributes, @user, @fb_profile) }

      its (:gender) { should eq 0 }
      its (:nickname) { should eq profile.nickname }
      its (:age) { should eq 28 }
    end
  end  
end
