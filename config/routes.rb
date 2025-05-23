Rails.application.routes.draw do
  root "home#index"
  get 'home/index'
  resources :crate_types, only: [:index, :show]
  resources :categories, only: [:index, :show]
  get '/about', to: 'pages#about', as: :about
  get '/contact', to: 'pages#contact', as: :contact
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  resource :cart, only: [:show] do
    post 'add'
    delete 'remove'
    patch 'update', as: 'update_quantity'
  end

  resources :checkout, only: [:index, :create]
  resources :addresses, except: [:index, :show] do
    member do
      patch :set_default
    end
  end
  resources :orders, only: [:index, :show] do
    resource :payment, only: [:create]
  end

  post 'stripe/webhook', to: 'payments#webhook'
end
