# coding: utf-8

FactoryGirl.define do
  factory :image, class: Image do
    user_id { User.all.sample.id }
    is_main false
  end
end
