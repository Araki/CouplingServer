# coding: utf-8

FactoryGirl.define do
  factory :message, class: Message do
    match_id { Match.all.sample.id }
    body     { Faker::Lorem.sentence(10) }
  end
end
