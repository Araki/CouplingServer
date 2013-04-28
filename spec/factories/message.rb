# coding: utf-8

FactoryGirl.define do
  factory :message, class: Message do
    match    { Match.all.sample }
    body     { Faker::Lorem.sentence(10) }
    talk_key { match.talk_key }
  end
end
