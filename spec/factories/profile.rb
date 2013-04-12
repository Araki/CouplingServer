# coding: utf-8

FactoryGirl.define do
  factory :profile do
    type    'Profile'
    user_id          1    
    group_id          1
    age               { 15 + rand(30) }
    alcohol           { rand(4) }
    birthplace        { rand(47) + 1 }
    blood_type        ['A', 'B', 'O', 'AB'].sample
    dislike         'goki'
    gender            { rand(1) }
    height            { rand(40) + 150 }
    holiday          { rand(4) }
    income           { rand(8) }
    introduction      { Faker::Lorem.sentence(40) }
    industry          0
    job               { rand(27) }
    job_description   ['会社員','医師','弁護士','公認会計士','経営者・役員','公務員','事務員','大手商社','外資金融','大手企業','大手外資','マスコミ・広告','クリエイター ','IT関連','パイロット','客室乗務員','芸能・モデル','アパレル・ショップ','アナウンサー ','イベントコンパニオン','受付',' 秘書','看護師','保育士','自由業','学生','その他'].sample
    marital_history   0
    marriage_time     0
    nickname          { Faker::Name.first_name }
    proportion        { rand(8) }
    prefecture       { rand(47) + 1 }
    roommate          { rand(4) }
    smoking           { rand(3) }
    sociability      '???'
    workplace        '渋谷区'
  end
end
