# -*r coding: utf-8 -*-
require 'spec_helper'

describe Member do
  before do
    @member = FactoryGirl.create(:member)
    @target_member = FactoryGirl.create(:member)
  end

  describe "#hobbies" do
    context 'hobbyを追加する前' do
      subject { @member.hobbies }

      its(:count) { should eq 0 }      
    end
    context 'hobbyを追加後' do
      before do
        5.times do
          @member.hobbies << FactoryGirl.create(:hobby)
        end
      end
      subject { @member.hobbies }

      its(:count) { should eq 5 }      
    end
  end

  describe "#specialities" do
    context 'specialityを追加する前' do
      subject { @member.specialities }

      its(:count) { should eq 0 }      
    end
    context 'specialityを追加後' do
      before do
        5.times do
          @member.specialities << FactoryGirl.create(:speciality)
        end
      end
      subject { @member.specialities }

      its(:count) { should eq 5 }      
    end
  end

  describe "#characters" do
    context 'characterを追加する前' do
      subject { @member.characters }

      its(:count) { should eq 0 }      
    end
    context 'specialityを追加後' do
      before do
        5.times do
          @member.characters << FactoryGirl.create(:character)
        end
      end
      subject { @member.characters }

      its(:count) { should eq 5 }      
    end
  end

  describe "#set_main_image" do
    context 'mainでない画像の場合' do
      let(:image) { FactoryGirl.create(:image, {member_id: @member.id, is_main: false}) }
      before do
        @member.set_main_image(image) 
      end
      subject { image.is_main }      
      
      it { should be_true } 
    end

    context 'main画像だった場合' do
      # let!遅延評価でないことに注意
      let!(:image) { FactoryGirl.create(:image, {member_id: @member.id, is_main: true}) }
      before do
        new_main_image =  FactoryGirl.create(:image, {member_id: @member.id, is_main: false})
        @member.set_main_image(new_main_image) 
      end
      subject { image.reload.is_main }      

      it { should be_false } 
    end
  end
end
