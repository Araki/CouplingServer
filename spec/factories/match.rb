# coding: utf-8

FactoryGirl.define do
  factory :match, class: Match do
    can_open_profile false
    messages_count 0

    factory :match_target_boys do
      target_id {User.find(:all, gender: 0).to_a.map(&:id).sample}
    end

    factory :match_target_girls do
      target_id {User.find(:all, gender: 1).to_a.map(&:id).sample}
    end
  end
end
