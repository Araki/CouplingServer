# coding: utf-8

FactoryGirl.define do
  factory :message, class: Message do
    match_id { Match.all.to_a.map(&:id).sample }
    body     { Faker::Lorem.sentence(10) }
  end
end
