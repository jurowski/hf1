ActionController::Routing::Routes.draw do |map|
  map.resources :message_tags

  map.resources :message_goals

  map.resources :messages

  map.resources :triggers

  map.resources :checkpoint_achievemints

  map.resources :template_achievemints

  map.resources :achievemints

  map.resources :level_goals

  map.resources :levels

  map.resources :template_tags

  map.resources :program_templates

  map.resources :program_tags

  map.resources :programs

  map.resources :organizations

  map.resources :quotetags

  map.resources :affiliates

  map.resources :goaltags

  map.resources :goaltemplates

  map.resources :tags

  map.resources :coachgoals

  map.resources :coaches

  map.resources :betpayees

  map.resources :bets

  map.resources :frommessages

  map.resources :tomessages

  map.resources :messages

  map.resources :teamgoals

  map.resources :teams

  map.resources :promotion1s

  map.resources :expiredcheckpoints

  map.resources :quotes

  map.resources :failedcheckpoints

  map.resources :stats

  map.resources :cheers


  map.connect '/', :controller => "user_sessions", :action => "new"

  map.resources :checkpoints
  
  map.connect 'checkpoints/:id/autoupdate', :controller => 'checkpoints', :action => 'autoupdate'
  map.connect 'checkpoints/:id/autoupdatemultiple', :controller => 'checkpoints', :action => 'autoupdatemultiple'
  map.connect 'checkpoints/:id/autoupdatemultipleradio', :controller => 'checkpoints', :action => 'autoupdatemultipleradio'


  map.resources :goals, :collection => { :autocomplete_for_goal_response_question => :get}
  
  map.resources :goals

  map.connect 'quicksignup_v2', :controller => 'users', :action => 'quicksignup_v2'

  map.connect 'goals/:id/shared', :controller => 'goals', :action => 'shared'

  map.resources :cheers

  map.resources :hooks
  map.connect 'hooks/order/create', :controller => 'hooks', :action => 'create'

  map.connect 'cheers/:id/shared', :controller => 'cheers', :action => 'shared'
  
  map.connect 'goals/:id/sharelinks', :controller => 'goals', :action => 'sharelinks'
    
  #map.connect '/shared.html', 'http://habitforge.com/shared.html')
  ########
  ### keep these in this order
  map.resource :account, :controller => "users"
  map.resources :password_resets
  map.resources :users
  map.resource :user_session
  ########
  

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  #map.root :controller => "users"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
