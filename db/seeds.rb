# -*- coding: utf-8 -*-

require 'factory_girl_rails'

User.delete_all
Session.delete_all
Like.delete_all
Match.delete_all
Favorite.delete_all
Message.delete_all
Image.delete_all
# Item.delete_all
MstPrefecture.delete_all

def create_images(user_id)
  0.upto(4) do |num|
    is_main = num > 0 ? false : true
    FactoryGirl.create(:image, {user_id: user_id, is_main: is_main})
  end
end

case Rails.env
when "development"
  
  # 主人公:session_id=abc
  user = FactoryGirl.create(:user, {
    id: 1,
    gender: 0, 
    nickname: 'taro',
    access_token: 'abcdefg',
    facebook_id: '1234567'
    })
  session = FactoryGirl.create(:session, {
   value: user.id.to_s,
   key: 'abc' 
   })
  create_images(user.id)

  # お相手:session_id=xyz
  target_user = FactoryGirl.create(:user, {
    id: 2,
    gender: 1, 
    nickname: 'atsuko',
    access_token: 'abcdefgxxx',
    facebook_id: '1234567xxx'
    })
  target_user_session = FactoryGirl.create(:session, {
   value: user.id.to_s,
   key: 'xyz'
   })
  create_images(target_user.id)

  # モブ:男女50人づつ、そのうち20人は画像を準備。
  boys = FactoryGirl.create_list(:boys, 50, {})
  boys.sample(20).each do |boy|
    create_images(boy.id)
  end
  girls = FactoryGirl.create_list(:girls, 50, {})
  girls.sample(20).each do |girl|
    create_images(girl.id)
  end

  # 主人公は10人のお気に入りと5人のmatchと10人のlikeと5人のlikedを持つ
  girls.sample(20).each_with_index do |girl, i|
    if i < 10
      user.favorite_users << girl
    end

    if i < 5
      user.match_users << girl
      girl.match_users << user
    elsif i < 15
      user.like_users << girl
    else
      girl.like_users << user 
    end    
  end

  #お相手との間のmatch
  match = FactoryGirl.create(:match, {user_id: user.id, target_id: target_user.id})
  target_match = FactoryGirl.create(:match, {user_id: target_user.id, target_id: user.id})

  #20回talkしている
  20.times do
    FactoryGirl.create(:message, {talk_key: "#{user.id}_#{target_user.id}", match_id: [match.id, target_match.id].sample})
  end

when "production"
end

MstPrefecture.create(name: "北海道")
MstPrefecture.create(name: "青森県")
MstPrefecture.create(name: "岩手県")
MstPrefecture.create(name: "宮城県")
MstPrefecture.create(name: "秋田県")
MstPrefecture.create(name: "山形県")
MstPrefecture.create(name: "福島県")
MstPrefecture.create(name: "群馬県")
MstPrefecture.create(name: "栃木県")
MstPrefecture.create(name: "茨城県")
MstPrefecture.create(name: "埼玉県")
MstPrefecture.create(name: "千葉県")
MstPrefecture.create(name: "東京都")
MstPrefecture.create(name: "神奈川県")
MstPrefecture.create(name: "新潟県")
MstPrefecture.create(name: "富山県")
MstPrefecture.create(name: "石川県")
MstPrefecture.create(name: "福井県")
MstPrefecture.create(name: "山梨県")
MstPrefecture.create(name: "長野県")
MstPrefecture.create(name: "岐阜県")
MstPrefecture.create(name: "静岡県")
MstPrefecture.create(name: "愛知県")
MstPrefecture.create(name: "三重県")
MstPrefecture.create(name: "滋賀県")
MstPrefecture.create(name: "京都府")
MstPrefecture.create(name: "大阪府")
MstPrefecture.create(name: "兵庫県")
MstPrefecture.create(name: "奈良県")
MstPrefecture.create(name: "和歌山県")
MstPrefecture.create(name: "鳥取県")
MstPrefecture.create(name: "島根県")
MstPrefecture.create(name: "岡山県")
MstPrefecture.create(name: "広島県")
MstPrefecture.create(name: "山口県")
MstPrefecture.create(name: "徳島県")
MstPrefecture.create(name: "香川県")
MstPrefecture.create(name: "愛媛県")
MstPrefecture.create(name: "高知県")
MstPrefecture.create(name: "福岡県")
MstPrefecture.create(name: "佐賀県")
MstPrefecture.create(name: "長崎県")
MstPrefecture.create(name: "熊本県")
MstPrefecture.create(name: "大分県")
MstPrefecture.create(name: "宮崎県")
MstPrefecture.create(name: "鹿児島県")
MstPrefecture.create(name: "沖縄県")
