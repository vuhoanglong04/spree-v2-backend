Rails.application.routes.draw do
  namespace :api do
    namespace :admin do
      resource :account_users
    end
  end
  devise_for :account_users, path: "api/auth", controllers: {
    sessions: 'api/auth/sessions',
    registrations: 'api/auth/registrations',
    confirmations: 'api/auth/confirmations',
    passwords: 'api/auth/passwords',
    omniauth_callbacks: 'api/auth/omniauth_callbacks'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
