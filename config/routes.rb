Rails.application.routes.draw do
  devise_for :users
  root to: "recipes#index"
  get "users/:id", to: "users#about", as: :about_user
  resources :matches, only: :show do
    member do
      patch :save
      patch :unsave
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  resources :matches, only: [:index, :create]
post 'matches/:id', to: 'matches#create', as: 'create_match'

  # Defines the root path route ("/")
  # root "posts#index"
end
