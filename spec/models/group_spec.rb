# -*r coding: utf-8 -*-
require 'spec_helper'

describe Group do
  before do
    @group = FactoryGirl.create(:group)
  end

  describe "#group_images" do
    context 'group_imageを追加する前' do
      subject { @group.group_images }

      its(:count) { should eq 0 }      
    end
    context 'group_imageを追加後' do
      before do
        5.times do
          @group.group_images << FactoryGirl.create(:group_image)
        end
      end
      subject { @group.group_images }

      its(:count) { should eq 5 }      
    end
  end

  describe "#days" do
    context 'dayを追加する前' do
      subject { @group.days }

      its(:count) { should eq 0 }      
    end
    context 'dayを追加後' do
      before do
        5.times do
          @group.days << FactoryGirl.create(:day)
        end
      end
      subject { @group.days }

      its(:count) { should eq 5 }      
    end
  end

  describe "#mst_prefectures" do
    context 'mst_prefectureを追加する前' do
      subject { @group.mst_prefectures }

      its(:count) { should eq 0 }      
    end
    context 'mst_prefectureを追加後' do
      before do
        5.times do
          @group.mst_prefectures << FactoryGirl.create(:mst_prefecture)
        end
      end
      subject { @group.mst_prefectures }

      its(:count) { should eq 5 }      
    end
  end
end