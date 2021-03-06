MlsAlmanac::Application.routes.draw do

  get '/' => 'static#index'
  get '/events' => 'static#index'
  get '/teams/:event_key' => 'static#index', as: :teams, :event_key => /.+\.[0-9_]+/
  get '/api' => redirect('/api/v1')
  mount SportDb::Service::Server, :at => '/api/v1'  # NB: make sure to require 'sportdb-service'

  mount SportDbAdmin::Engine, :at => '/sportdb'  # mount a root possible?

  # Can specify the format for each parameter with a regex.  The dot in event keys can be tricky...
  # Assume all events have a dot
  # Assume all teams don't
  get 'roster/:event_key/:team_key' => 'roster#index', as: :roster, :event_key => /.+\.[0-9_]+/
  get 'schedule/:event_key/:team_key' => 'schedule#index', as: :schedule, :event_key => /.+\.[0-9_]+/
  get 'team_home/:event_key/:team_key' => 'team#index', as: :team, :event_key => /.+\.[0-9_]+/

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
