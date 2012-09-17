Coupling::Application.routes.draw do
  get "index/top"
  get "index/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  get 'api/v1/session/register/:facebook_id/' => 'session#register'
  get 'api/v1/session/create/:facebook_id/' => 'session#create'
  get 'api/v1/session/destroy' => 'session#destroy'

  get 'api/v1/user/profile/:facebook_id/' => 'user#profile_get'
  post 'api/v1/user/profile/:facebook_id/' => 'user#profile_post'
  get 'api/v1/user/list' => 'user#list'
  get 'api/v1/user/like' => 'user#like_get'
  post 'api/v1/user/like' => 'user#like_post'
  get 'api/v1/user/favorite' => 'user#favorite_get'
  post 'api/v1/user/favorite' => 'user#favorite_post'
  get 'api/v1/user/likelist' => 'user#likelist'
  get 'api/v1/user/block' => 'user#block_get'
  post 'api/v1/user/block' => 'user#block_post'
  get 'api/v1/user/blocklist' => 'user#blocklist'
  get 'api/v1/user/talk/:facebook_id/' => 'user#talk_get'
  post 'api/v1/user/talk/:facebook_id/' => 'user#talk_post'

  match 'api/v1/iap/pay' => 'iap#pay'
  match 'api/v1/iap/history' => 'iap#history'
  
  match 'api/v1/point/add' => 'point#add'
  match 'api/v1/point/info' => 'point#info'
  match 'api/v1/point/use' => 'point#use'

  match 'api/v1/push/add' => 'push#add'

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
