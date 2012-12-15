Coupling::Application.routes.draw do
  get "push/add"
  get "index/top"
  get "index/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  get '/session/register' => 'session#register'
  get '/session/verify' => 'session#verify'
  get '/session/destroy' => 'session#destroy'

  get '/user/profile/:facebook_id/' => 'user#profile_get'
  post '/user/profile/:facebook_id/' => 'user#profile_post'
  get '/user/list' => 'user#list'
  get '/user/like' => 'user#like_get'
  post '/user/like' => 'user#like_post'
  get '/user/favorite' => 'user#favorite_get'
  post '/user/favorite' => 'user#favorite_post'
  get '/user/likelist' => 'user#likelist'
  get '/user/block' => 'user#block_get'
  post '/user/block' => 'user#block_post'
  get '/user/blocklist' => 'user#blocklist'
  get '/user/talk/:facebook_id/' => 'user#talk_get'
  post '/user/talk/:facebook_id/' => 'user#talk_post'

  match '/iap/pay' => 'iap#pay'
  match '/iap/history' => 'iap#history'
  
  match '/point/add' => 'point#add'
  match '/point/info' => 'point#info'
  match '/point/use' => 'point#use'

  match '/push/add' => 'push#add'

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'index#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
