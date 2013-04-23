# coding: utf-8

FactoryGirl.define do
  factory :receipt, class: Receipt do
    receipt_code { Faker::Lorem.characters(30) }
    user_id { User.all.sample.id }
    item_id { Item.all.sample.id }
  end

  factory :invalid_receipt, class: Receipt do
    receipt_code nil
    user_id { User.all.sample.id }
    item_id { Item.all.sample.id }
  end
end
