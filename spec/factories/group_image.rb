# coding: utf-8

FactoryGirl.define do
  factory :group_image, class: GroupImage do
    name "元気"
  end
  factory :invalid_group_image, class: GroupImage do
    name nil
  end
end
