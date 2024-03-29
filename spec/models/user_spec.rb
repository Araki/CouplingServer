# -*r coding: utf-8 -*-
require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.create(:user)
    @profile = FactoryGirl.create(:profile, {user_id: @user.id})
    @target_user = FactoryGirl.create(:user)
  end

  describe ".create_or_find_by_access_token" do
    context 'facebook認証に成功した場合' do
      before do
        graph = mock("graph")
        Koala::Facebook::API.stub!(:new).with('facebookaccesstoken').and_return(graph)
        fb_profile = {
          id: '1234567890',
          email: 'test@example.com',
          first_name: "First", 
          last_name: "Last", 
          gender: "male",
          birthday: 28.years.ago.strftime("%m/%d/%Y")
        }
        graph.stub!(:get_object).with('me').and_return(fb_profile)
      end

      context '既存のユーザーがあれば' do
        before do
          user = FactoryGirl.create(:user, {facebook_id: 1234567890})
          FactoryGirl.create(:profile, {user_id: user.id})
        end

        it {expect{User.create_or_find_by_access_token('facebookaccesstoken', 'appledevicetoken') }.to change(User, :count).by(0)}
        it {expect{User.create_or_find_by_access_token('facebookaccesstoken', 'appledevicetoken') }.to change(Profile, :count).by(0)}
      end

      context '既存のユーザーがなければ' do
        before do
          User.stub!(:find_by_access_token).with('facebookaccesstoken').and_return(nil)
          user = User.new
          User.stub!(:new).and_return(user)
        end

        it {expect{User.create_or_find_by_access_token('facebookaccesstoken', 'appledevicetoken')}.to change(User, :count).by(1)}
        it {expect{User.create_or_find_by_access_token('facebookaccesstoken', 'appledevicetoken')}.to change(Profile, :count).by(1)}
      end      
    end
    context 'facebook認証に成功しなかった場合' do
      before do
        graph = mock("graph")
        Koala::Facebook::API.stub!(:new).with('facebookaccesstoken').and_return(graph)
        fb_profile = {}
        graph.stub!(:get_object).with('me').and_return(fb_profile)
      end

      context 'エラーになること' do
        it {expect{User.create_or_find_by_access_token('facebookaccesstoken', 'appledevicetoken') }.to raise_error}
      end
    end
  end

  describe "#infos" do
    context '自分宛と全員あてがとれること' do
      subject { @user.infos() }
      before do
        FactoryGirl.create_list(:info, 5, {:body => 'lalala', :target_id => @user.id})
        FactoryGirl.create_list(:info, 6, {:body => 'lalala', :target_id => -1})
        FactoryGirl.create_list(:info, 7, {:body => 'lalala', :target_id => 100})
      end

      its(:count) { should eq 11 }
    end
  end

  describe "#like?" do
    subject { @user.like?(@target_user) }

    context 'まだlikeされていないユーザーに対して' do
      it { should be_false }
    end

    context 'Likeされたユーザーに対して' do
      before do
        @user.like_users << @target_user
      end

      it { should be_true }
    end
  end

  describe "#liked?" do
    subject { @user.liked?(@target_user) }

    context 'まだlikeされていないユーザーに対して' do
      it { should be_false }
    end

    context 'Likeされたユーザーに対して' do
      before do
        @target_user.like_users << @user
      end

      it { should be_true }
    end
  end

  describe "#match?" do
    subject { @user.match?(@target_user) }

    context 'まだmatchされていないユーザーに対して' do
      let(:target) { FactoryGirl.create(:user) }

      it { should be_false }
    end

    context 'matchされたユーザーに対して' do
      before do
        @target_user.match_users << @user
        @user.match_users << @target_user
      end

      it { should be_true }
    end
  end

  describe "#over_likes_limit_per_day?" do
    before do
      @girls = FactoryGirl.create_list(:girls, 10)
    end
    subject { @user.over_likes_limit_per_day? }

    context '当日のlikeの数がlikes_limit_per_day以下だったら' do
      before do
        (configatron.likes_limit_per_day - 1).times do |n|
          FactoryGirl.create(:like_target_girls, {user_id: @user.id, target_id: @girls[n].id})
        end
      end

      it { should be_false }
    end

    context '当日のlikeの数がlikes_limit_per_day以上だったら' do
      before do
        configatron.likes_limit_per_day.times do |n|
          FactoryGirl.create(:like_target_girls, {user_id: @user.id, target_id: @girls[n].id})
        end
      end

      it { should be_true }
    end
  end

  describe "#create_match" do
    before do
      @target_user.like_users << @user
    end

    context 'まだmatchされていないユーザーに対して' do
      context 'matchを返すこと' do
        it { @user.create_match(@target_user).should eq({type: 'match'}) }
      end

      context '相互にmatchされること' do
        before do
          @user.create_match(@target_user) 
        end

        it do
          @user.match?(@target_user).should be_true
          @target_user.match?(@user).should be_true
        end
      end
      
      context 'matchが2つ増えること' do
        it {expect{@user.create_match(@target_user) }.to change(Match, :count).by(2)}
      end

      context 'likeが1つ減ること' do
        it {expect{@user.create_match(@target_user) }.to change(Like, :count).by(-1)}
      end
    end

    context 'すでにmatchされていたら' do
      before do
        @target_user.match_users << @user
        @user.match_users << @target_user
      end
      subject { @user.create_match(@target_user) }

      it { should eq({:message=>"internal_server_error"}) }
    end
  end

  describe "#create_like" do
    context '相手からLikeされていない場合' do
      context 'まだlikeしていないユーザーに対して' do
        context 'likeを返すこと' do
          it { @user.create_like(@target_user).should eq({type: 'like'}) }
        end

        context 'likeされること' do
          before do
            @user.create_like(@target_user) 
          end

          it {@target_user.liked?(@user).should be_true} 
        end
        
        context 'likeが1つ増えること' do
          it {expect{@user.create_like(@target_user) }.to change(Like, :count).by(1)}
        end
      end

      context 'すでにlikeしていたら' do
        before do
          @user.like_users << @target_user
        end
        subject { @user.create_like(@target_user) }

        context 'likeを返すこと' do
          it { should eq({:message=>"internal_server_error"}) }
        end
        
        context 'likeが増えないこと' do
          it { expect{ @user.create_like(@target_user) }.to change(Like, :count).by(0)}
        end
      end
    end

    context '既に相手からLikeされている場合' do
      before do
        @target_user.like_users << @user
      end

      context 'まだlikeしていないユーザーに対して' do
        context 'matchを返すこと' do
          it { @user.create_like(@target_user).should eq({type: 'match'}) }
        end

        context 'likedでなくなること' do
          before do
            @user.create_like(@target_user) 
          end

          it {@target_user.liked?(@user).should be_false} 
        end

        context 'matchになること' do
          before do
            @user.create_like(@target_user) 
          end

          it { @user.match?(@target_user).should be_true } 
        end
        
        context 'likeが1つ減ること' do
          it { expect{@user.create_like(@target_user) }.to change(Like, :count).by(-1) }
        end
        
        context 'Matchが2つ増えること' do
          it { expect{@user.create_like(@target_user) }.to change(Match, :count).by(2) }
        end
      end
    end

    it 'like_pointが増えること'
  end

  describe "#add_point" do
    let(:user) { FactoryGirl.create(:user, :point => 100) }
    subject { user.reload.point }

    context '正の整数を渡されたら' do
      before do
        user.add_point(50)
      end

      it { should eq 150 }
    end

    context '負の整数を渡されたら' do
      before do
        user.add_point(-50)
      end

      it { should eq 100 }
    end
  end

  describe "#consume_point" do
    let(:user) { FactoryGirl.create(:user, :point => 100) }
    subject { user.reload.point }

    context '正の整数を渡されたら' do
      before do
        user.consume_point(50)
      end

      it { should eq 50 }
    end

    context '持ちポイントより多く使われたら' do
      before do
        user.consume_point(150)
      end

      it { should eq 100 }
    end

    context '負の整数を渡されたら' do
      before do
        user.consume_point(-50)
      end

      it { should eq 100 }
    end
  end

  describe "#assign_fb_attributes" do
    before do
      graph = mock("graph")
      Koala::Facebook::API.stub!(:new).with('facebookaccesstoken').and_return(graph)
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
      let(:user) { User.new() }
      subject { user.send(:assign_fb_attributes, @fb_profile, 'facebookaccesstoken', 'appledevicetoken') }

      its (:facebook_id) { should eq 1234567890 }
      its (:email) { should eq 'test@example.com' }
      its (:gender) { should eq 0 }
    end

    context '既存のユーザーの場合' do
      let(:user) { FactoryGirl.create(:user, {gender: 1, facebook_id: 999}) }
      subject { user.send(:assign_fb_attributes, @fb_profile, 'facebookaccesstoken', 'appledevicetoken') }

      its (:facebook_id) { should eq 999 }
      its (:email) { should eq 'test@example.com' }
      its (:gender) { should eq 0 }
    end
  end  
end
