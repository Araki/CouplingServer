# coding: utf-8

FactoryGirl.define do
  factory :like, class: Like do
    factory :like_target_boys do
      target_id {
        User.find(:all, gender: 0).to_a.map(&:id).sample
      }
    end
    factory :like_target_girls do
      target_id {
        User.find(:all, gender: 1).to_a.map(&:id).sample
      }
    end
  end
end
