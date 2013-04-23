# coding: utf-8

FactoryGirl.define do
  factory :image, class: Image do
    member_id { Profile.all.sample.id }
    is_main false
  end

  factory :invalid_image, class: Image do
    member_id nil
    is_main false
  end
end
