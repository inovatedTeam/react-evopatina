Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :activities
  put 'move_activity/:id', to: 'activities#move', as: 'move_activity'

  resources :subsectors
  put 'move_subsector/:id', to: 'subsectors#move', as: 'move_subsector'

  resources :sectors
  put 'move_sector/:id', to: 'sectors#move', as: 'move_sector'

  root 'days#show'

  get 'days/:date', to: 'days#show', as: 'week'

  put 'fragments/:id', to: 'fragments#update', as: 'fragment'

  devise_for :users, skip: [:sessions],
    controllers: {
      registrations: "users/registrations",
      passwords: "users/passwords",
      confirmations: "users/confirmations",
      sessions: "users/sessions"
    }
  as :user do
    get 'confirm', to: 'users/registrations#confirm'
    get 'signin' => 'users/sessions#new', :as => :new_user_session
    post 'signin' => 'users/sessions#create', :as => :user_session
    delete 'signout' => 'users/sessions#destroy', :as => :destroy_user_session
  end

  get 'patina', to: 'pages#patina', as: 'patina'
  get 'about', to: 'pages#about', as: 'about'
  get 'how_to', to: 'pages#how_to', as: 'how_to'
  get 'hello' => 'pages#hello', :as => :hello

  get 'statistics', to: 'pages#statistics', as: 'statistics'
  get 'statistics/:id', to: 'pages#statistics_sector', as: 'statistic'

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
