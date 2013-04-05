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

  describe "#create_message" do
    context 'messageが作成されること' do
      it {expect{@match.create_message(body: 'hahaha') }.to change(Message, :count).by(1)}
    end

    context 'targetからもmessageが取得できること' do
      before do
        @match.create_message(body: 'lalala')
      end
      subject { @oppsite_match.talks(nil) }

      its (:size) { should eq 1 }
    end

    #以下factorygirlのカウンターキャッシュの不具合のためエラーとなる

    context 'message_countが増えること' do
      before do
        @match.create_message(body: 'lalala')
      end

      it { @match.reload.messages_count.should eq 1 }
    end

    context '2通づつmessageを送ったらcan_open_profileはfalseであること' do
      before do
        1.times do
          @match.create_message(body: 'lalala')
        end
        1.times do
          @match.pair.create_message(body: 'hahaha')
        end
      end

      it { @match.reload.can_open_profile.should be_false }
    end

    context '3通づつmessageを送ったら' do
      before do
        3.times do
          @match.create_message(body: 'lalala')
        end
        3.times do
          @match.pair.create_message(body: 'hahaha')
        end
      end

      it { @match.messages.count.should eq 3 }
      it { @match.reload.can_open_profile.should be_true }
    end

    it 'NGワードの書き込みができないこと'
  end
end