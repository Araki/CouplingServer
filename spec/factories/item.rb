# coding: utf-8

FactoryGirl.define do
  factory :item, class: Item do
    title "10ポイント"
    sequence(:pid) { |n| "com.example.products.100gems#{n}" }
    point 100
    receipts_count 0
  end

  factory :invalid_item, class: Item do
    title nil
    sequence(:pid) { |n| "com.example.products.100gems#{n}" }
    point 100
    receipts_count 0
  end
end

