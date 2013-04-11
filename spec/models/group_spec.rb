# -*r coding: utf-8 -*-
require 'spec_helper'

describe Group do
  before do
    @group = FactoryGirl.create(:group)
  end

  describe "#group_images" do
    context 'hobbyを追加する前' do
      subject { @group.group_images }

      its(:count) { should eq 0 }      
    end
    context 'hobbyを追加後' do
      before do
        5.times do
          @group.group_images << FactoryGirl.create(:group_image)
        end
      end
      subject { @group.group_images }

      its(:count) { should eq 5 }      
    end
  end
end