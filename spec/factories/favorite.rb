# coding: utf-8

FactoryGirl.define do
  factory :favorite, class: Favorite do
    factory :favorite_target_boys do
      target_id {User.find_all_by_gender(0).sample.id}
    end

    factory :favorite_target_girls do
      target_id {User.find_all_by_gender(1).sample.id}
    end
  end
end
