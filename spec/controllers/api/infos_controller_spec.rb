# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::InfosController do
  before do
    @user = FactoryGirl.create(:user)
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
  end

  describe '#list' do
    context 'Infoがある場合' do
      before do
        FactoryGirl.create_list(:info, 5, {:body => 'lalala', :target_id => @user.id})
        FactoryGirl.create_list(:info, 6, {:body => 'lalala', :target_id => -1})
        FactoryGirl.create_list(:info, 7, {:body => 'lalala', :target_id => 100})
      end

      context 'ターゲットと全員向けのInfoが返ること' do
        before do
          get :list, {session_id: @session.key}
        end

        it do
          # response.body.should ==  ''
          parsed_body = JSON.parse(response.body)
          parsed_body["current_page"].should == 1
          parsed_body["infos"].length.should == 11
          parsed_body["last_page"].should == true
        end
      end
    end
  end
end