# -*r coding: utf-8 -*-
require 'spec_helper'

describe Message do
  describe "#count_and_save" do
    before do
      @user = FactoryGirl.create(:user)
      @profile = FactoryGirl.create(:profile, {user_id: @user.id})
      @target_user = FactoryGirl.create(:user)
      @target_user_profile = FactoryGirl.create(:profile, {user_id: @target_user.id})
      @session = FactoryGirl.create(:session, { value: @user.id.to_s })

      @match =  FactoryGirl.create(:match, {user_id: @user.id, profile_id: @target_user_profile.id})
      @oppsite_match =  FactoryGirl.create(:match, {user_id: @target_user.id, profile_id: @profile.id}) 
    end

    context 'count_and_saveについて' do
      before do
        @message = Message.new(:match_id => @match.id, :talk_key => @match.talk_key, :body => 'lalala' )
        @oppsite_message = Message.new(:match_id => @oppsite_match.id, :talk_key => @oppsite_match.talk_key, :body => 'hahaha' )
      end

      context 'messageが作成されること' do
        it {expect{@message.count_and_save(@match) }.to change(Message, :count).by(1)}
      end

      context 'targetからもmessageが取得できること' do
        before do
          @message.count_and_save(@match)
        end
        subject { @oppsite_match.talks(nil) }

        its (:size) { should eq 1 }
      end

      #以下factorygirlのカウンターキャッシュの不具合のためエラーとなる

      context 'message_countが増えること' do
        before do
          @message.count_and_save(@match)
        end

        it { @match.reload.messages.count.should eq 1 }
      end
    end

    context 'can_open_profileについて' do
      context '2通づつmessageを送ったらcan_open_profileはfalseであること' do
        before do
          FactoryGirl.create_list(:message, 1, {:match_id => @match.id, :talk_key => @match.talk_key, :body => 'lalala'})
          FactoryGirl.create_list(:message, 3, {:match_id => @oppsite_match.id, :talk_key => @match.talk_key, :body => 'lalala'})

          @message = Message.new(:match_id => @match.id, :talk_key => @match.talk_key, :body => 'lalala' )
          @message.count_and_save(@match)
        end

        it { @match.messages.count.should eq 2 }
        it { @oppsite_match.messages.count.should eq 3 }
        it { @match.reload.can_open_profile.should be_false }
      end

      context '3通づつmessageを送ったら' do
        before do
          FactoryGirl.create_list(:message, 2, {:match_id => @match.id, :talk_key => @match.talk_key, :body => 'lalala'})
          FactoryGirl.create_list(:message, 3, {:match_id => @oppsite_match.id, :talk_key => @match.talk_key, :body => 'lalala'})

          @message = Message.new(:match_id => @match.id, :talk_key => @match.talk_key, :body => 'lalala' )
          @result = @message.count_and_save(@match)
        end

        it { @result.should be_true }
        it { @match.messages.count.should eq 3 }
        it { @oppsite_match.messages.count.should eq 3 }
        it { @match.reload.can_open_profile.should be_true }
      end
    end


    it 'NGワードの書き込みができないこと'
  end
end