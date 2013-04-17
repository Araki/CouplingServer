# -*r coding: utf-8 -*-
require 'spec_helper'
require 'timeout'

describe ApplicationController do
  # before do
  #   @user = FactoryGirl.create(:user)
  #   @profile = FactoryGirl.create(:profile, {user_id: @user.id})
  #   @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  # end

  describe '#push_notification' do
    controller do
      def index
        user = FactoryGirl.create(:user)
        profile = FactoryGirl.create(:profile, {user_id: user.id})
        match = FactoryGirl.create(:match, { profile_id: profile.id, unread_count: 10})

        push_notification(user, 'abcdefghijklmnopqrstuvwxyz')
        render text: 'ok'
      end
    end

    context 'Pushした場合' do
      before do
        @server = Grocer.server(port: 2195)
        @server.accept # starts listening in background
        get :index
      end

      after do
        @server.close
      end

      it do
        notification = @server.notifications.pop
        expect(notification.alert).to eq("abcdefghijklmnopq...")
      end
      it do
        notification = @server.notifications.pop
        expect(notification.badge).to eq(10)
      end
    end
  end
end