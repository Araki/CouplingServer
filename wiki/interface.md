## session/create

初期登録時に叩くAPI。iOSクライアント側でFacebook Connectし、アクセストークンを投げると、サーバー側でセッションIDを生成してレスポンスを返す。ログイントークンはクライアント側でNSUserDefaults等に保存しておいて、以降のログインではそれを使用する。

### URL

    GET /api/user/session/create/:access_token

param | require | description
------|---------|------
access_token | o | Connectで得られたそのユーザーのFacebookのアクセストークン

### Response Sample

    {"status":"ok","session":"lhzB_XmdfmEP","user":{"id":2,"facebook_id":1319832574,"profile_status":null,"email":null,"certification":null,"certification_status":null,"public_status":null,"first_login_at":null,"last_login_at":null,"invitation_code":null,"contract_type":null,"like_point":null,"point":null,"nickname":null,"introduction":null,"gender":null,"age":null,"country":null,"language":null,"address":null,"birthplace":null,"roommate":null,"height":null,"proportion":null,"constellation":null,"blood_type":null,"marital_history":null,"marriage_time":null,"want_child":null,"relationship":null,"have_child":null,"smoking":null,"alcohol":null,"industry":null,"job":null,"job_description":null,"workplace":null,"income":null,"qualification":null,"school":null,"holiday":null,"sociability":null,"character":null,"speciality":null,"hobby":null,"dislike":null,"login_token":null,"created_at":"2013-01-07T17:06:13Z","updated_at":"2013-01-07T17:06:13Z"}}

## session/verify

すでに初期登録が済んでいた場合（NSUserDefaultsにsession_idがあった場合）にsession_idを使ってログインする。そのsession_idが使えるものであった場合、trueを返す。以降それを使って他のAPIをコールする。

### URL

    GET /api/user/session/verify?session_id=#{session_id}

param | require | description
------|---------|------
session_id| o |セッションID

### Response Sample

    {"status":"ok","session":"lhzB_XmdfmEP","user":{"id":2,"facebook_id":1319832574,"profile_status":null,"email":null,"certification":null,"certification_status":null,"public_status":null,"first_login_at":null,"last_login_at":null,"invitation_code":null,"contract_type":null,"like_point":null,"point":null,"nickname":null,"introduction":null,"gender":null,"age":null,"country":null,"language":null,"address":null,"birthplace":null,"roommate":null,"height":null,"proportion":null,"constellation":null,"blood_type":null,"marital_history":null,"marriage_time":null,"want_child":null,"relationship":null,"have_child":null,"smoking":null,"alcohol":null,"industry":null,"job":null,"job_description":null,"workplace":null,"income":null,"qualification":null,"school":null,"holiday":null,"sociability":null,"character":null,"speciality":null,"hobby":null,"dislike":null,"login_token":null,"created_at":"2013-01-07T17:06:13Z","updated_at":"2013-01-07T17:06:13Z"}}

## session/destroy

ユーザーのほうから明示的にログアウトした場合に呼ばれる。セッションIDを破棄するので、次回ユーザーがアプリを起動したときにはFacebook認証をしなおしsession#createしなければならない。

### URL

    GET /api/user/session/destroy?session_id=#{session_id}

param | require | description
------|---------|------
session_id| o | セッションID

### Response Sample

#### Success

    {"status":"ok"}

## profile/show

user_idを指定するとそのユーザのプロフィールを返す。

user_idを指定しなければ現在のセッションのユーザのプロフィールを返す。

### URL

    GET /api/user/profile/show

param | require | description
------|---------|------
session_id| o | セッションID
user_id| - | ユーザID

### Request Sample

    GET /api/user/profile/show?session_id=abcd1234

### Response Sample

     {"status":"ok","id":2,"facebook_id":1319832574,"profile_status":null,"email":null,"certification":null,"certification_status":null,"public_status":null,"first_login_at":null,"last_login_at":null,"invitation_code":null,"contract_type":null,"like_point":null,"point":null,"nickname":null,"introduction":null,"gender":null,"age":null,"country":null,"language":null,"address":null,"birthplace":null,"roommate":null,"height":null,"proportion":null,"constellation":null,"blood_type":null,"marital_history":null,"marriage_time":null,"want_child":null,"relationship":null,"have_child":null,"smoking":null,"alcohol":null,"industry":null,"job":null,"job_description":null,"workplace":null,"income":null,"qualification":null,"school":null,"holiday":null,"sociability":null,"character":null,"speciality":null,"hobby":null,"dislike":null,"login_token":null,"created_at":"2013-01-07T17:06:13Z","updated_at":"2013-01-07T17:06:13Z"}

## profile/edit

自分のプロフィール情報を追加・更新する。

### URL

    POST /api/user/profile/edit

param | require | description
------|---------|------
session_id| o | セッションID

### Request Sample

    POST /api/user/profile/edit
    session_id:abcd1234

### Response Sample


## user/list

    GET /user/list/

### URL

    GET /api/user/list

* #{session_id} セッションID
* #{filter_key} フィルターをかける条件のキーを指定する liked
* #{filter_value} フィルターをかける条件の値を指定する true
* #{start_index} 取得するデータのオフセット値　デフォルトは0
* #{count} 取得する最大件数 デフォルトは50件  

### 仕様の変更を検討（天野：2012年10月20日）
* https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
* #{max_id} #{since_id}を指定してリストの読み込み範囲を指定するようにする
* #{start_index}と#{count}ではリアルタイムな更新があるとどこから読み込めばいいかわからなくなる。

### Request Sample

    GET /api/user/list?session_id=abcd1234&filter_by=liked&filter_value=true&start_index=0&count=5

### Response Sample

    {"status":"ok","user":[]}

## like/add

### URL

    POST /api/user/like/add

param | require | description
------|---------|------
session_id| o | セッションID

### Request Sample

    GET /api/user/like/add?session_id=abcd1234

### Response Sample


## like/show

### URL

    GET /api/user/like/show

* #{session_id} セッションID

### Request Sample

    GET /api/user/like/show?session_id=abcd1234

### Response Sample

    {"status":"ok","like":[]}

## 特定のユーザーにメッセージを送る

### URL

    POST http://coupling.herokuapp.com/api/v1/user/talk/#{facebook_id}/

* #{facebook_id} メッセージを送る相手のFacebookID
* #{session_id} セッションID
* #{message} メッセージの内容

### Request Sample

    POST /api/v1/user/talk/123456789
    session_id:abcd1234
    message:こんにちは

### Response Sample

    202 Accepted

## 特定のユーザーと自分の間のメッセージ履歴を取得する

相手のFacebookIDを渡すと、その相手とのメッセージ履歴を返す。

### URL

    GET http://coupling.herokuapp.com/api/v1/user/talk/#{facebook_id}/

* #{facebook_id} メッセージ相手のFacebookID
* #{session_id} セッションID

### Request Sample

    GET /api/v1/user/talk/987654321?session_id=abcd1234

### Response Sample

    200 OK
    {
        'talk-2':
        {
            'facebook_id':12345678,
            'message':'こんにちは'
        },
        'talk-1':
        {
            'facebook_id':987654321,
            'message':'はじめまして'
        }
    }

## In App Purchace購入操作

### URL

    POST http://coupling.herokuapp.com/api/v1/iap/pay/#{facebook_id}/

* #{facebook_id} 購入するユーザーのFacebookID。@meのみ
* #{session_id} セッションID
* #{item_id} 購入するアイテムID
* #{amount} 購入数
* #{transaction_id} トランザクションID

### Request Sample

    POST /api/v1/iap/pay/@me/
	session_id:abcd1234
	item_id:3
	amount:1
	transaction_id:xxxxxxxxxxxxxxxxxxxxxx

### Response Sample

    202 Accepted

## ポイント付与

### URL

    POST http://coupling.herokuapp.com/api/v1/point/add/#{facebook_id}/

* #{facebook_id} ポイントを付与する対象のFacebookID
* #{session_id} セッションID
* #{amount} ポイント付与量

### Request Sample

    POST /api/v1/point/add/123456789/
    session_id:abcd1234
    amount:300

### Response Sample

    202 Accepted

## ポイントを使う

### URL

    POST http://coupling.herokuapp.com/api/v1/point/use/#{facebook_id}/

* #{facebook_id} ポイントを使う対象のFacebookID。@meのみ
* #{session_id} セッションID
* #{amount} ポイント消費量

### Request Sample

    POST /api/v1/point/add/@me/
    session_id:abcd1234
    amount:300

### Response Sample

    202 Accepted

## トークン登録

### URL

    POST http://coupling.herokuapp.com/api/v1/push/add/#{facebook_id}/

* #{facebook_id} ポイントを付与する対象のFacebookID
* #{push_token} PUSH通知用のトークン

### Request Sample

    POST /api/v1/point/add/123456789/
    session_id:abcd1234
    push_token:AbCdEfGhIj1234567890AbCdEfGhIj123

### Response Sample

    202 Accepted
