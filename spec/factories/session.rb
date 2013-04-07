# coding: utf-8

FactoryGirl.define do
  factory :session, class: Session do
    sequence(:key) { |n| "abcdefg#{n}" }
    value { User.all.to_a.map(&:id).sample }
  end
end
