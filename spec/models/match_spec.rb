# -*r coding: utf-8 -*-
require 'spec_helper'

describe Match do
  before do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, {user_id: @user.id})
    @target_user = FactoryGirl.create(:user)
    @target_user_profile = FactoryGirl.create(:profile, {user_id: @target_user.id})

    @match =  FactoryGirl.create(:match, {user_id: @user.id, profile_id: @target_user_profile.id})
    @oppsite_match =  FactoryGirl.create(:match, {user_id: @target_user.id, profile_id: @profile.id}) 
  end

  describe "#pair" do
    context '対となるmatchを返すこと' do
      subject { @oppsite_match.pair }

      it { should eq @match }
    end
    context '対となるmatchを返すこと2' do
      subject { @match.pair }

      it { should eq @oppsite_match }
    end
  end

  describe "#talk_key" do
    context '2つのmatchのidを結合したキーを返すこと' do
      subject { @match.talk_key }

      it { should eq "#{@user.id}_#{@target_user.id}" }
    end
  end

  describe "#talks" do
    before do
      @messages = FactoryGirl.create_list(:message, 5, {match_id: @match.id, talk_key: @match.talk_key})
      @replys = FactoryGirl.create_list(:message, 5, {match_id: @oppsite_match.id, talk_key: @oppsite_match.talk_key})
    end

    context 'since_idがなければトーク全体を返すこと' do
      subject { @match.talks(nil) }

      its (:size) { should eq 10 }
    end

    context 'since_idがあるとそれ以降を返すこと' do
      subject { @match.talks(@messages.last.id) }

      its (:size) { should eq 5 }
    end
  end

  describe "#reset_unread_count" do
    context 'countについて' do
      let!(:match) { FactoryGirl.create(:match, {unread_count: 5, user_id: 5, profile_id: 7}) }
      subject { match.unread_count }
      before do
        match.reset_unread_count
      end

      it { should eq 0 }
    end

    context 'last_read_atについて' do
      let!(:match) { FactoryGirl.create(:match, {unread_count: 5, user_id: 5, profile_id: 10}) }
      subject { match.last_read_at }
      before do
        Time.stub!(:now).and_return(Time.local(2013,4,6,14,0,0))
        match.reset_unread_count
      end

      it { should eq Time.local(2013,4,6,14,0,0) }
    end
  end
end