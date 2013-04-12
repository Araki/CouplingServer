# coding: utf-8

FactoryGirl.define do
  factory :group, class: Group do
    user_id  1
    max_age 30
    min_age 25
    head_count 1
    relationship "あいうえお"
    request "あいうえお"
    opening_hour Time.now
    target_age_range 0
    area "渋谷"
  end
end

