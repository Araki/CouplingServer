# coding: utf-8

FactoryGirl.define do
  factory :session, class: Session do
    sequence(:key) { |n| "abcdefg#{n}" }
    value { User.all.sample.id }
  end
  factory :invalid_session, class: Session do
    sequence(:key) { |n| "abcdefg#{n}" }
    value nil
  end
end
