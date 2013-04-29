# coding: utf-8

FactoryGirl.define do
  factory :receipt, class: Receipt do
    receipt_code { Faker::Lorem.characters(30) }
    user { User.all.sample }
    item { Item.all.sample }
  end

  factory :invalid_receipt, class: Receipt do
    receipt_code nil
    user { User.all.sample }
    item { Item.all.sample }
  end
end
