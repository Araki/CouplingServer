# coding: utf-8

FactoryGirl.define do
  factory :session, class: Session do
    sequence(:key) { |n| "abcdefg#{n}" }
    value { User.all.sample.id }
  end
end
