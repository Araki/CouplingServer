# coding: utf-8

FactoryGirl.define do
  factory :message, class: Message do
    match    { Match.all.sample }
    user     { |a| a.match.user }
    target   { |a| a.match.target }
    body     { Faker::Lorem.sentence(10) }
  end
end
