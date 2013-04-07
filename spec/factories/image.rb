# coding: utf-8

FactoryGirl.define do
  factory :image, class: Image do
    user_id { User.all.to_a.map(&:id).sample }
    is_main false
    order_number 0
  end
end
