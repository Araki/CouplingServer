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

  describe "#group_images" do
    context 'dayを追加する前' do
      subject { @group.group_images }

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

  describe "#save_group" do
    before do
      @days = FactoryGirl.create_list(:day, 10)
      @mst_prefectures = FactoryGirl.create_list(:mst_prefecture, 10)
      @group_images = FactoryGirl.create_list(:group_image, 10)
      @group.days << [@days[0], @days[1], @days[2]]
      @group.mst_prefectures << [@mst_prefectures[0], @mst_prefectures[1], @mst_prefectures[2]]
      @group.group_images << [@group_images[0], @group_images[1], @group_images[2]]
    end
    context '正常な値を渡した場合' do
      before do
        @group.save_group({group: {relationship: 'dada'}, group_images: [@group_images[3].id, @group_images[4].id]})
      end

      it { @group.relationship.should eq 'dada' }      
      it { @group.group_images.length.should eq 2 }      
      it { @group.mst_prefectures.length.should eq 3 }      
    end
    
    context '不正な値を渡した場合' do
      it {@group.save_group(group: {target_age_range: 100}).should be_false}
    end

    context '不正な値を渡した場合2' do
      it {@group.save_group(group_images: [@group_images[3].id, @group_images[4].id, @group_images[5].id, @group_images[6].id]).should be_false}
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