# coding: utf-8

FactoryGirl.define do
  factory :match, class: Match do
    user_id { User.all.sample.id }
    profile_id { Profile.all.sample.id }
    can_open_profile false
    unread_count 0
    last_read_at 10.days.ago

    factory :match_target_boys do
      profile_id {Profile.find_all_by_gender(0).sample.id}
    end

    factory :match_target_girls do
      profile_id {Profile.find_all_by_gender(1).sample.id}
    end
  end
end
