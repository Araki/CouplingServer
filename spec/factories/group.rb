# coding: utf-8

FactoryGirl.define do
  factory :group, class: Group do
    status   1
    user_id  1
    max_age { 30 + rand(15) }
    min_age { 20 + rand(10)}
    head_count {rand(3)}
    relationship { Faker::Lorem.word }
    request { Faker::Lorem.sentence(1) }
    opening_hour Time.now
    target_age_range 0
    area { Faker::Address.city }
  end
end

