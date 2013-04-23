# coding: utf-8

FactoryGirl.define do
  factory :speciality, class: Speciality do
    name "早食い"
  end

  factory :invalid_speciality, class: Speciality do
    name nil
  end
end
