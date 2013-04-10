# coding: utf-8

FactoryGirl.define do
  factory :receipt, class: Receipt do
    sequence(:receipt_code) { |n| "ewoJInNpZ25hdHVyZSIgPSAi...#{n}" }
    user_id 1
    item_id 1
  end
end
