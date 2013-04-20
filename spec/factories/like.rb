# coding: utf-8

FactoryGirl.define do
  factory :like, class: Like do
    factory :like_target_boys do
      profile_id {Profile.find_all_by_gender(0).sample.id}
    end
    factory :like_target_girls do
      profile_id {Profile.find_all_by_gender(1).sample.id}
    end
  end
end
