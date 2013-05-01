# coding: utf-8

FactoryGirl.define do
  factory :character, class: Character do
    name "温厚"
  end
  factory :invalid_character, class: Character do
    name nil
  end
end
