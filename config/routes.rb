   require 'sidekiq/web'

Rails.application.routes.draw do
  get "dashboard/index"
  resources :aircrafts
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
   root "dashboard#index"
   resources :dashboard, only: [:index] do
    collection do
      get :profile
    end
  end
   get "flight_blocks/calendar", to: "flight_blocks#calendar", as: :calendar

   resources :flight_blocks

    resources :flight_blocks do
      member do
        patch :no_show
      end
    end
   #get "calendar", to: "flight_blocks#calendar", as: :calendar

  # tus otras rutas...

  # Solo para admin. ¡PROTEGER ESTA RUTA!
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :admin do
      get "pending", to: "users#pending", as: :pending_users
  resources :maintenances, only: [:new, :create, :index, :destroy]

    resources :users, only: [:index, :edit, :update, :destroy] do
      member do
        patch :approve
      end
    end
  end

  


end
