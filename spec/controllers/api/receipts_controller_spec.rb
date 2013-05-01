# -*r coding: utf-8 -*-
require 'spec_helper'

describe Api::ReceiptsController do
  before do
    @user = FactoryGirl.create(:user)
    @session = FactoryGirl.create(:session, { value: @user.id.to_s })
    @item = FactoryGirl.create(:item, { title: "300point", point: 300, pid: 'com.example.products.300pt' })
  end

  describe '#list' do
    before do
      10.times do
        FactoryGirl.create(:receipt, {user_id: @user.id, item_id: @item.id})
      end
    end

    context 'アイテムの購入履歴がある場合' do
      before do
        get :list, {session_id: @session.key}
      end

      it 'アイテムのリストが返ること' do
        # response.body.should ==  ''
        parsed_body = JSON.parse(response.body)
        parsed_body["current_page"].should == 1
        parsed_body["receipts"].length.should == 10
        parsed_body["last_page"].should == true
        parsed_body["receipts"][0]["item"].should == "300point"
      end
    end
  end

  describe '#validate' do

    context 'receipt_codeのレシートが存在しない場合' do
      context '正常なレシートの場合' do
        before do
          iap_receipt = mock(:iap_receipt)
          iap_receipt.stub!(:product_id).and_return( 'com.example.products.300pt')
          iap_receipt.stub!(:quantity).and_return(1)
          Itunes::Receipt.should_receive(:verify!).with('abcde', :allow_sandbox).and_return(iap_receipt)
        end

        it 'Receiptが作成されること' do
          expect{
            post :validate, {receipt_data: 'abcde', session_id: @session.key}
          }.to change(Receipt, :count).by(1)
        end

        it 'itemが返ること' 
      end

      context '正常なレシートの場合' do
        before do
          iap_receipt = mock(:iap_receipt)
          iap_receipt.stub!(:product_id).and_return( 'com.example.products.300pt')
          iap_receipt.stub!(:quantity).and_return(1)
          Itunes::Receipt.should_receive(:verify!).with('abcde', :allow_sandbox).and_return(iap_receipt)
          post :validate, {receipt_data: 'abcde',session_id: @session.key}
        end

        it 'itemが返ること' do
          JSON.parse(response.body)['item']['point'].should == 300
        end
      end

      it 'iapのsandboxでのテスト？' 

      context '不正なレシートの場合' do
        before do
          Itunes::Receipt.stub!(:verify!).with('abcde', :allow_sandbox).and_raise(Itunes::Receipt::VerificationFailed.new)
          post :validate, {receipt_data: 'abcde', session_id: @session.key}
        end

        it 'ngが返ること' do
          JSON.parse(response.body)['code'].should == 'Itunes::Receipt::VerificationFailed'
        end
      end
    end

    context 'receipt_codeのレシートが既に存在する場合' do
      before do
        FactoryGirl.create(:receipt, {receipt_code: 'abcde', user_id: @user.id, item_id: @item.id})
        post :validate, {receipt_data: 'abcde', session_id: @session.key}
      end

      it 'invalid_receiptが返ること' do
        JSON.parse(response.body)['code'].should == 'Itunes::Receipt::VerificationFailed'
      end
    end
  end
end