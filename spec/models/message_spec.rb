# -*r coding: utf-8 -*-
require 'spec_helper'

describe Message do
  describe "#save_message" do
    before do
      @user = FactoryGirl.create(:user)
      @profile = FactoryGirl.create(:profile, {user: @user})
      @target = FactoryGirl.create(:user)

      @match =  FactoryGirl.create(:match, {user: @user, target: @target})
      @inverse_match =  FactoryGirl.create(:match, {user: @target, target: @user}) 
    end

    context 'save_messageについて' do
      before do
        @message = Message.new(:match_id => @match.id, :user_id => @user.id, :body => 'lalala' )
        @inverse_message = Message.new(:match_id => @inverse_match.id, :user_id => @target.id, :body => 'hahaha' )
      end

      context '成功した場合' do
        it {@message.save_message(@match).should be_true }
      end

      context 'messageが作成されること' do
        it {expect{@message.save_message(@match) }.to change(Message, :count).by(1)}
      end

      context 'targetからもmessageが取得できること' do
        before do
          @message.save_message(@match)
        end
        subject { Message.by_matches(@inverse_match.id, @inverse_match.inverse.id) }

        its (:size) { should eq 1 }
      end
    end

    context 'can_open_profileについて' do
      context '2通づつmessageを送ったらcan_open_profileはfalseであること' do
        before do
          FactoryGirl.create_list(:message, 1, {:match => @match, :user => @user, :body => 'lalala'})
          FactoryGirl.create_list(:message, 3, {:match => @inverse_match, :user => @user, :body => 'lalala'})

          @message = Message.new(:match_id => @match.id, :user_id => @user.id, :body => 'lalala' )
          @message.save_message(@match)
        end

        it { @match.messages.count.should eq 2 }
        it { @inverse_match.messages.count.should eq 3 }
        it { @match.reload.can_open_profile.should be_false }
        it { @inverse_match.reload.can_open_profile.should be_false }
      end

      context '3通づつmessageを送ったら' do
        before do
          FactoryGirl.create_list(:message, 2, {:match => @match, :user => @user, :body => 'lalala'})
          FactoryGirl.create_list(:message, 3, {:match => @inverse_match, :user => @target, :body => 'lalala'})

          @message = Message.new(:match_id => @match.id, :user_id => @user.id, :body => 'lalala' )
          @result = @message.save_message(@match)
        end

        it { @result.should be_true }
        it { @match.messages.count.should eq 3 }
        it { @inverse_match.messages.count.should eq 3 }
        it { @match.reload.can_open_profile.should be_true }
        it { @inverse_match.reload.can_open_profile.should be_true }
      end
    end


    it 'NGワードの書き込みができないこと'
  end
end