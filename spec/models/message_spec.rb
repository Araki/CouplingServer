# -*r coding: utf-8 -*-
require 'spec_helper'

describe Message do
  # describe "#count_and_save" do
  #   before do
  #     @user = FactoryGirl.create(:user)
  #     @profile = FactoryGirl.create(:profile, {user: @user})
  #     @target = FactoryGirl.create(:user)

  #     @match =  FactoryGirl.create(:match, {user: @user, target: @target})
  #     @inverse_match =  FactoryGirl.create(:match, {user: @target, target: @user}) 
  #   end

  #   context 'count_and_saveについて' do
  #     before do
  #       @message = Message.new(:match_id => @match.id, :user_id => @user.id, :target_id => @target.id, :body => 'lalala' )
  #       @inverse_message = Message.new(:match_id => @inverse_match.id, :target_id => @user.id, :user_id => @target.id, :body => 'hahaha' )
  #     end

  #     context '成功した場合' do
  #       it {@message.count_and_save(@match).should be_true }
  #     end

  #     context 'messageが作成されること' do
  #       it {expect{@message.count_and_save(@match) }.to change(Message, :count).by(1)}
  #     end

  #     context 'targetからもmessageが取得できること' do
  #       before do
  #         @message.count_and_save(@match)
  #       end
  #       subject { @inverse_match.talks(nil) }

  #       its (:size) { should eq 1 }
  #     end

  #     #以下factorygirlのカウンターキャッシュの不具合のためエラーとなる

  #     context 'message_countが増えること' do
  #       before do
  #         @message.count_and_save(@match)
  #       end

  #       it { @match.reload.messages.count.should eq 1 }
  #     end
  #   end

  #   context 'unread_countについて' do
  #     before do
  #       @message = Message.new(:match_id => @match.id, :user_id => @user.id, :target_id => @target.id, :body => 'lalala' )
  #     end

  #     context '作成前' do
  #       subject { @inverse_match.reload }

  #       its (:unread_count) { should eq 0 }
  #     end

  #     context '成功したら2' do
  #       before do
  #         @message.count_and_save(@match)
  #       end
  #       subject { @inverse_match.reload }

  #       its (:unread_count) { should eq 1 }
  #     end
  #   end

    # context 'can_open_profileについて' do
    #   context '2通づつmessageを送ったらcan_open_profileはfalseであること' do
    #     before do
    #       FactoryGirl.create_list(:message, 1, {:match => @match, :user => @user, :target => @target, :body => 'lalala'})
    #       FactoryGirl.create_list(:message, 3, {:match => @inverse_match, :user => @user, :target => @target, :body => 'lalala'})

    #       @message = Message.new(:match_id => @match.id, :user_id => @user.id, :target_id => @target.id, :body => 'lalala' )
    #       @message.count_and_save(@match)
    #     end

    #     it { @match.messages.count.should eq 2 }
    #     it { @inverse_match.messages.count.should eq 3 }
    #     it { @match.reload.can_open_profile.should be_false }
    #     it { @inverse_match.reload.can_open_profile.should be_false }
    #   end

    #   context '3通づつmessageを送ったら' do
    #     before do
    #       FactoryGirl.create_list(:message, 2, {:match => @match, :user => @user, :target => @target, :body => 'lalala'})
    #       FactoryGirl.create_list(:message, 3, {:match => @inverse_match, :user => @target, :target => @user, :body => 'lalala'})

    #       @message = Message.new(:match_id => @match.id, :user_id => @user.id, :target_id => @target.id, :body => 'lalala' )
    #       @result = @message.count_and_save(@match)
    #     end

    #     it { @result.should be_true }
    #     it { @match.messages.count.should eq 3 }
    #     it { @inverse_match.messages.count.should eq 3 }
    #     it { @match.reload.can_open_profile.should be_true }
    #     it { @inverse_match.reload.can_open_profile.should be_true }
    #   end
    # end


  #   it 'NGワードの書き込みができないこと'
  # end
end