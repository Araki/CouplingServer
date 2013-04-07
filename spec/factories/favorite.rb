# coding: utf-8

FactoryGirl.define do
  factory :favorite, class: Favorite do
    factory :favorite_target_boys do
      target_id {User.find(:all, gender: 0).to_a.map(&:id).sample}
    end
    factory :favorite_target_girls do
      target_id {User.find(:all, gender: 1).to_a.map(&:id).sample}
    end
  end
end
