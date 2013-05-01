# coding: utf-8

FactoryGirl.define do
  factory  :friend, :class => Friend, :parent => :member do
    type    'Friend'
    group_id          1

    factory :male_friend do
      gender 0
    end

    factory :female_friend do
      gender 1
    end

    factory :valid_friend do
      nickname 'taro'
    end

    factory :invalid_friend do
      nickname nil
    end
  end
end
