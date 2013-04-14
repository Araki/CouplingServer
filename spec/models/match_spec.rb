# -*r coding: utf-8 -*-
require 'spec_helper'

describe Match do
  before do
    @user = FactoryGirl.create(:user)
    @target_user = FactoryGirl.create(:user)

    @match =  FactoryGirl.create(:match, {user_id: @user.id, target_id: @target_user.id})
    @oppsite_match =  FactoryGirl.create(:match, {user_id: @target_user.id, target_id: @user.id}) 
  end

  describe "#pair" do
    context '対となるmatchを返すこと' do
      subject { @oppsite_match.pair }

      it { should eq @match }
    end
  end

  describe "#talk_key" do
    context '2つのmatchのidを結合したキーを返すこと' do
      let(:match) { FactoryGirl.create(:match, {user_id: 50, target_id: 100}) }
      subject { match.talk_key }

      it { should eq '50_100' }
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
end