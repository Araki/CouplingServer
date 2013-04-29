# -*- coding: utf-8 -*-
Coupling::Application.routes.draw do

  get "index/top"
  get "index/index"

  namespace :api do

    post '/sessions/create' => 'user/sessions#create'
    get  '/sessions/verify' => 'user/sessions#verify'
    post '/sessions/destroy' => 'user/sessions#destroy'

    get  '/account/show_profile' => 'user/account#show_profile'
    post '/account/update_profile' => 'user/account#update_profile'
    post '/account/destroy' => 'user/account#destroy'

    get  '/profiles/list' => 'profiles#list'
    get  '/profiles/:id/show' => 'profiles#show'

    get  '/groups/show' => 'groups#show'
    get  '/groups/list' => 'groups#list'
    get  '/groups/search' => 'groups#search'
    post '/groups/create' => 'groups#create'
    post '/groups/update' => 'groups#update'

    get  '/friends/:id/show' => 'friends#show'
    post '/friends/create' => 'friends#create'
    post '/friends/:id/update' => 'friends#update'
    post '/friends/:id/destroy' => 'friends#destroy'

    get  '/images/list' => 'images#list'
    post '/images/create' => 'images#create'
    post '/images/:id/destroy' => 'images#destroy'
    post '/images/:id/set_main' => 'images#set_main'

    get  '/likes/list' => 'likes#list'
    post '/likes/create' => 'likes#create'
    
    get  '/favorites/list' => 'favorites#list'
    post '/favorites/create' => 'favorites#create'
    post '/favorites/destroy' => 'favorites#destroy', :as => 'favorites_destroy'

    post '/points/add' => 'points#add'
    post '/points/consume' => 'points#consume'

    get  '/matches/list' => 'matches#list'

    get  '/messages/list' => 'messages#list'
    post '/messages/create' => 'messages#create'

    get  '/infos/list' => 'infos#list'

    get  'receipts/list' => 'receipts#list'
    post 'receipts/validate' => 'receipts#validate'
  end

  namespace :admin do
    resources :users, :except => [:new, :create] do
      resources :profiles, :except => [:new, :create]
      resources :groups, :except => [:new, :create] do
        resources :friends, :except => [:new, :create]
      end

      resources :favorites, :only => [:index, :destroy]
      resources :likes, :only => [:index, :destroy]
      resources :matches, :only => [:index, :destroy] do
        resources :messages, :only => [:index, :destroy]
      end
      resources :messages, :only => [:index, :destroy]
      resources :receipts
      resources :infos
    end
    resources :friends, :except => [:new, :create]
    resources :profiles, :except => [:new, :create]
    resources :groups, :except => [:new, :create]
    resources :characters
    resources :items
    resources :group_images
    resources :specialities
    resources :hobbies
    resources :images, :only => [:index, :show, :destroy]
    resources :infos
    resources :receipts
    resources :sessions
    resources :statics, :only => [:index]

    get 'statics/by_month' => 'statics#by_month', :as => :statics_by_month
    get 'statics/by_day' => 'statics#by_day', :as => :statics_by_day
  end

  get  '/admin' => 'admin/users#index'
  
  root :to => 'index#index'
end
