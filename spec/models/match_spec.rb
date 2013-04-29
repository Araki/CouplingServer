# -*r coding: utf-8 -*-
require 'spec_helper'

describe Match do
  before do
    @user = FactoryGirl.create(:user)
    @target = FactoryGirl.create(:user)

    @match =  FactoryGirl.create(:match, {user: @user, target: @target})
    @inverse_match =  FactoryGirl.create(:match, {user: @target, target: @user}) 
  end

  describe "#inverse" do
    context '対となるmatchを返すこと' do
      subject { @inverse_match.inverse }

      it { should eq @match }
    end
    context '対となるmatchを返すこと2' do
      subject { @match.inverse }

      it { should eq @inverse_match }
    end
  end

  describe "#talks" do
    before do
      @messages = FactoryGirl.create_list(:message, 5, {match: @match, user: @target, target: @user})
      @replys = FactoryGirl.create_list(:message, 5, {match: @inverse_match, user: @user, target: @target})
    end

    context 'since_idがなければトーク全体を返すこと' do
      subject { Message.by_matches(@match.id, @match.inverse.id) }

      its (:size) { should eq 10 }
    end
  end
end