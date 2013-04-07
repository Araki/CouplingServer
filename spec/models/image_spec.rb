# -*r coding: utf-8 -*-
require 'spec_helper'

describe Image do
  before do
    @user = FactoryGirl.create(:user)
  end

  describe ".create_user_iamge" do
    context 'imageがなかった場合' do
      subject { Image.create_user_iamge(@user)}

      it { should be_a_kind_of Image }
      its(:is_main) { should be_true }
      its(:user_id) { should eq @user.id }
      its(:order_number) { should eq 1 }
    end

    context 'imageがあった場合' do
      before do
       FactoryGirl.create(:image, {user_id: @user.id, is_main: true })
      end
      subject { Image.create_user_iamge(@user)}

      it { should be_a_kind_of Image }
      its(:is_main) { should be_false }
      its(:user_id) { should eq @user.id }
      its(:order_number) { should eq 2 }
    end
  end

  describe "#url" do
    let(:image) { FactoryGirl.create(:image, {user_id: @user.id}) }
    subject { image.url }

    it do 
      str = "https:\/\/pairful-development\.s3\.amazonaws\.com\/pairful\/image\/" + 
        "#{image.created_at.strftime('%Y%m%d')}\/" + 
        "#{@user.id}\.png\\?AWSAccessKeyId=(.*)&Expires=(\\d+)&Signature=(.*)"
      should match /#{str}/
    end
  end

  describe "#upload_parameter" do
    let(:image) { FactoryGirl.create(:image, {user_id: @user.id}) }
    context 'urlについて' do
      subject { image.upload_parameter }

      its ([:url]) {should eq "https://pairful-development.s3.amazonaws.com/"}
    end
    context 'urlについて' do
      subject { image.upload_parameter[:fields] }

      its (['AWSAccessKeyId']) {should eq "AKIAIOQ4BVQW426SIRFA"}
      its (['key']) {should eq "pairful/image/#{image.created_at.strftime('%Y%m%d')}/#{image.id}.png"}
      its (['acl']) {should eq ""}
    end
  end

  describe "#destroy_entity_and_file" do
    let!(:image) { FactoryGirl.create(:image, {user_id: @user.id}) }

    context '削除に成功したら' do
      it {expect{image.destroy_entity_and_file }.to change(Image, :count).by(-1)}
    end

    it 'S3での削除のテストはどうすればよいか'
  end
end