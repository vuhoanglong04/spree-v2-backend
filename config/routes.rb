Rails.application.routes.draw do
  resources :return_requests
  resources :refunds
  resources :payments
  resources :promotions
  resources :order_items
  resources :orders
  resources :cart_items
  resources :carts
  resources :product_variant_attr_values
  resources :attribute_values
  resources :attributes
  resources :product_variants
  resources :product_images
  resources :product_categories
  resources :products
  resources :category_closures
  resources :categories
  resources :user_roles
  resources :role_permissions
  resources :permissions
  resources :roles
  resources :user_identities
  resources :user_profiles
  devise_for :account_users
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
