# coding: utf-8

FactoryGirl.define do
  factory :hobby, class: Hobby do
    name "スポーツ観戦"
  end

  factory :invalid_hobby, class: Hobby do
    name nil
  end
end
