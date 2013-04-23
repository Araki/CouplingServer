# coding: utf-8

FactoryGirl.define do
  factory :info, class: Info do
    target_id { User.all.sample.id }
    body     { Faker::Lorem.sentence(10) }
  end

  factory :invalid_info, class: Info do
    target_id { User.all.sample.id }
    body     nil
  end
end
