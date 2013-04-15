# coding: utf-8

FactoryGirl.define do
  factory :match, class: Match do
    can_open_profile false

    factory :match_target_boys do
      profile_id {Profile.find_all_by_gender(0).sample.id}
    end

    factory :match_target_girls do
      profile_id {Profile.find_all_by_gender(1).sample.id}
    end
  end
end
