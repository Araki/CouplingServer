# coding: utf-8

FactoryGirl.define do
  factory :like, class: Like do
    factory :like_target_boys do
      target_id {User.find_all_by_gender(0).sample.id}
    end
    factory :like_target_girls do
      target_id {User.find_all_by_gender(1).sample.id}
    end
  end
end
