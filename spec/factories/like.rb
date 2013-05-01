# coding: utf-8

FactoryGirl.define do
  factory :like, class: Like do
    user { User.all.sample }
    target { User.all.sample }

    factory :like_target_boys do
      target {Profile.find_all_by_gender(0).sample.user}
    end
    factory :like_target_girls do
      target {Profile.find_all_by_gender(1).sample.user}
    end
  end
end

