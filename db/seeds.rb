# -*- coding: utf-8 -*-

require 'factory_girl_rails'

User.delete_all
Session.delete_all
Like.delete_all
Match.delete_all
Favorite.delete_all
Group.delete_all
Message.delete_all
Member.delete_all
Image.delete_all
Item.delete_all
Info.delete_all
Receipt.delete_all
Day.delete_all
GroupDay.delete_all
GroupImage.delete_all
GroupGroupImage.delete_all
Character.delete_all
MemberCharacter.delete_all
Speciality.delete_all
MemberSpeciality.delete_all
Hobby.delete_all
MemberHobby.delete_all
MstPrefecture.delete_all
GroupMstPrefecture.delete_all

prefectures = ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","群馬県","栃木県","茨城県","埼玉県","千葉県","東京都",
  "神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県","滋賀県","京都府","大阪府",
  "兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県",
  "長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"].map{|prefecture|MstPrefecture.create({name: prefecture})} 

group_images = ['あかるい', '元気', 'さわやか','知的','真面目','上品'].map{|image|GroupImage.create({name: image})} 

days = ['日','月','火','水','木','金','土'].map{|day|Day.create({name: day})}

characters = ['優しい','素直','誠実','明るい','社交的','人見知り','知的','ドライ','ロマンチスト','几帳面','穏やか','寂しがり',
  '負けず嫌い','家庭的','優柔不断','決断力がある','天然','インドア','アウトドア','楽観的','真面目','知的','照れ屋','いつも笑顔',
  '上品','落ち着いている','謙虚','厳格','冷静','好奇心旺盛','家庭的','仕事好き','責任感がある','包容力がある','面白い','さわやか',
  '行動力かがある','熱い','気か','利く'].map{|character|Character.create({name: character})}

hobbies = ['映画鑑賞','スポーツ','スポーツ観戦','音楽鑑賞','カラオケ','バンド゙','料理','グルメ','お酒','ショッピング゙','ファッション',
  'アウトドア','車','バイク','ドライブ','習いごと','語学','読書','漫画','テレビ','ゲーム','インターネット','ギャンブル','ペット',
  'フィットネス','株式投資',' その他','特になし'].map{|hobby|Hobby.create({name: hobby})}

specialities = ['スポーツ','茶道','華道','華道','早食い','一輪車'].map{|speciality|Speciality.create({name: speciality})}

items = [
  {title: "100ポイント", pid: "com.pairful.products.100pt", point: 100},
  {title: "300ポイント", pid: "com.pairful.products.300pt", point: 300},
  {title: "500ポイント", pid: "com.pairful.products.500pt", point: 500},
  {title: "1000ポイント", pid: "com.pairful.products.1000pt", point: 1000},
  {title: "無限ポイント", pid: "com.pairful.products.infinity", point: 0}
].map{|item|Item.create(item)}

def create_images(profile_id)
  0.upto(4) do |num|
    is_main = num > 0 ? false : true
    FactoryGirl.create(:image, {member_id: profile_id, is_main: is_main})
  end
end

case Rails.env
when "development"
  
  # 主人公:session_id=abc
  user = FactoryGirl.create(:user, {
    access_token: 'abcdefg',
    facebook_id: '1234567'
    })
  user_profile = FactoryGirl.create(:male_profile, {
    user_id: user.id,
    nickname: 'taro',
    })
  session = FactoryGirl.create(:session, {
   value: user.id.to_s,
   key: 'abc' 
   })
  create_images(user_profile.id)
  user_profile.hobbies << hobbies.sample(3)
  user_profile.characters << characters.sample(3)
  user_profile.specialities << specialities.sample(3)

  # お相手:session_id=xyz
  target_user = FactoryGirl.create(:user, {
    access_token: 'abcdefgxxx',
    facebook_id: '1234567xxx'
    })
  target_user_profile = FactoryGirl.create(:female_profile, {
    user_id: target_user.id,
    nickname: 'atsuko',
    })
  target_user_session = FactoryGirl.create(:session, {
   value: user.id.to_s,
   key: 'xyz'
   })
  create_images(target_user_profile.id)
  target_user_profile.hobbies << hobbies.sample(3)
  target_user_profile.characters << characters.sample(3)
  target_user_profile.specialities << specialities.sample(3)

  # モブ:男女50人づつ','そのうち20人は画像を準備。
  males = FactoryGirl.create_list(:user, 50, {})
  females = FactoryGirl.create_list(:user, 50, {})

  male_profiles = []
  males.each do |male|
    male_profiles << FactoryGirl.create(:profile, {user_id: male.id})
  end

  female_profiles = []
  females.each do |female|
    female_profiles << FactoryGirl.create( :female_profile, {user_id: female.id})
  end

  # 主人公は10人のお気に入りと5人のmatchと10人のlikeと5人のlikedを持つ
  females.sample(20).each_with_index do |female, i|
    if i < 10
      user.favorite_profiles << female.profile
    end

    if i < 5
      user.match_profiles << female.profile
      female.match_profiles << user.profile
    elsif i < 15
      user.like_profiles << female.profile
    else
      female.like_profiles << user.profile
    end    
  end

  #お相手との間のmatch
  match = FactoryGirl.create(:match, {user_id: user.id, profile_id: target_user_profile.id})
  target_match = FactoryGirl.create(:match, {user_id: target_user.id, profile_id: user_profile.id})

  #20回talkしている
  20.times do
    FactoryGirl.create(:message, {talk_key: "#{user.id}_#{target_user.id}", match_id: [match.id, target_match.id].sample})
  end

  males_group = FactoryGirl.create(:males_group, {user_id: user.id})
  males_group.group_images << group_images.sample(3)
  males_group.days << days.sample(3)
  males_group.mst_prefectures << prefectures.sample(3)
  3.times do
    friend = FactoryGirl.create(:male_friend, {group_id: males_group.id})
    friend.hobbies << hobbies.sample(3)
    friend.characters << characters.sample(3)
    friend.specialities << specialities.sample(3)
  end

  males_groups = []
  male_profiles.sample(20).each do |males_profile|
    group = FactoryGirl.create(:males_group, {user_id: males_profile.user_id})
    group.group_images << group_images.sample(3)
    group.days << days.sample(3)
    group.mst_prefectures << prefectures.sample(3)
    3.times do
      friend = FactoryGirl.create(:male_friend, {group_id: group.id})
      friend.hobbies << hobbies.sample(3)
      friend.characters << characters.sample(3)
      friend.specialities << specialities.sample(3)
    end
    males_groups << group
  end
  male_profiles.sample(20).each do |male_profile|
    create_images(male_profile.id)
  end

  females_groups = []
  female_profiles.sample(20).each do |female_profile|
    group = FactoryGirl.create(:females_group, {user_id: female_profile.user_id})
    group.group_images << group_images.sample(3)
    group.days << days.sample(3)
    group.mst_prefectures << prefectures.sample(3)
    3.times do
      friend = FactoryGirl.create(:female_friend, {group_id: group.id})
      friend.hobbies << hobbies.sample(3)
      friend.characters << characters.sample(3)
      friend.specialities << specialities.sample(3)
    end
    females_groups << group
  end
  female_profiles.sample(20).each do |female_profile|
    create_images(female_profile.id)
  end

  20.times do
    FactoryGirl.create(:info, {target_id: [-1,-1,-1,1].sample})
  end

  FactoryGirl.create_list(:receipt, 20)
  FactoryGirl.create_list(:receipt, 10, {user_id: 1})

when "production"
end
