# coding: utf-8

FactoryGirl.define do
  factory :match, class: Match do
    user { User.all.sample }
    target { User.all.sample }
    can_open_profile false
    last_read_at { 3.days.ago }

    factory :match_target_boys do
      target {Profile.find_all_by_gender(0).sample.user}
    end

    factory :match_target_girls do
      target {Profile.find_all_by_gender(1).sample.user}
    end
  end
end
