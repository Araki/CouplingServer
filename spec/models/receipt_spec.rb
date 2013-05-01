# -*r coding: utf-8 -*-
require 'spec_helper'

describe Receipt do
  before do
    @user = FactoryGirl.create(:user, {point: 100})
    @item = FactoryGirl.create(:item, { title: "300point", point: 300, pid: 'com.example.products.300pt' })
  end

  describe "#valid_and_save" do
    context '有効なreceiptの場合' do
      before do
        iap_receipt = mock(:iap_receipt)
        iap_receipt.stub!(:product_id).and_return( 'com.example.products.300pt')
        iap_receipt.stub!(:quantity).and_return(1)
        Itunes::Receipt.should_receive(:verify!).with('abcde', :allow_sandbox).and_return(iap_receipt)
        @receipt = Receipt.new({user_id:@user.id, receipt_code: 'abcde'})
      end

      it 'Receiptが作成されること' do
        expect{
          @receipt.valid_and_save
        }.to change(Receipt, :count).by(1)
      end

      context 'itemのreceipts_countが増えること' do
        before do
          @receipt.valid_and_save
        end
        subject { @item.reload.receipts_count}

        it { should eq 1}
      end

      context 'userにポイントが加算されること' do
        before do
          @receipt.valid_and_save
        end
        subject { @user.reload.point}

        it { should eq 400}
      end
    end

    context '無効なreceiptの場合' do
      before do
        iap_receipt = mock(:iap_receipt)
        iap_receipt.stub!(:product_id).and_return( 'com.example.products.300pt')
        iap_receipt.stub!(:quantity).and_return(1)
        Itunes::Receipt.should_receive(:verify!).with('abcde', :allow_sandbox).and_raise(Itunes::Receipt::VerificationFailed.new)
        @receipt = Receipt.new({user_id:@user.id, receipt_code: 'abcde'})
      end

      context 'iap_server_errorになること' do
        it 'Receiptが作成されないこと' do
          expect{
            @receipt.valid_and_save
          }.to raise_error(Itunes::Receipt::VerificationFailed)
        end
      end
    end

    context 'itemがみつからない場合' do
      before do
        iap_receipt = mock(:iap_receipt)
        iap_receipt.stub!(:product_id).and_return( 'com.example.products.xxxxxxx')
        iap_receipt.stub!(:quantity).and_return(1)
        Itunes::Receipt.should_receive(:verify!).with('abcde', :allow_sandbox).and_return(iap_receipt)
        @receipt = Receipt.new({user_id:@user.id, receipt_code: 'abcde'})
      end

      it 'Receiptが作成されないこと' do
        expect{
          @receipt.valid_and_save
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'トランザクションに失敗した場合' do
      before do
         FactoryGirl.create(:item, { title: "300point", point: 300, pid: 'com.example.products.-300pt' })
        iap_receipt = mock(:iap_receipt)
        iap_receipt.stub!(:product_id).and_return( 'com.example.products.-300pt')
        iap_receipt.stub!(:quantity).and_return(1)
        Itunes::Receipt.should_receive(:verify!).with('abcde', :allow_sandbox).and_return(iap_receipt)
        @receipt = Receipt.new({user_id:@user.id, receipt_code: 'abcde'})
        @receipt.stub!(:save!).and_raise(ActiveRecord::RecordInvalid.new(@receipt))
        
        ActiveRecord::Base.connection.should_receive(:rollback_db_transaction).once
      end

      it 'Receiptが作成されないこと' do
        expect{
          @receipt.valid_and_save
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end