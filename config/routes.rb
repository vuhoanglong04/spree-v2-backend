Rails.application.routes.draw do
  namespace :api do
    namespace :admin do
      resources :account_users
      resources :permissions
      resources :roles
      resources :user_roles
      resources :orders
      resources :products do
        member do
          post :restore
        end
        resources :product_variants do
          member do
            post :restore
          end
        end
      end
      resources :product_attributes do
        member do
          post :restore
        end
      end

      resources :promotions do
        member do
          post :restore
        end
      end

      resources :categories do
        member do
          post :restore
        end
      end
    end
  end

  devise_for :account_users, path: "api/auth", controllers: {
    sessions: 'api/auth/sessions',
    registrations: 'api/auth/registrations',
    confirmations: 'api/auth/confirmations',
    passwords: 'api/auth/passwords',
    omniauth_callbacks: 'api/auth/omniauth_callbacks'
  }
  devise_scope :account_user do
    namespace :api do
      namespace :auth do
        post "sign_out", to: "sessions#destroy"
        post "refresh", to: "sessions#refresh"

        post "confirm_email", to: "confirmations#confirm_email"
        post "resend_confirmation", to: "confirmations#resend_confirmation_instructions"

        post "reset_password", to: "passwords#create"
        post "check_reset_password_token", to: "passwords#check_reset_password_token"
        patch "reset_password", to: "passwords#update_password"

        get "get_google_oauth2_url", to: "omniauth_callbacks#get_google_oauth2_url"
        get "google_oauth2/callback", to: "omniauth_callbacks#callback"
      end
    end
  end

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
