Rails.application.routes.draw do

  devise_for :users

  authenticate :user, ->(u) { u.admin? } do
    mount MissionControl::Jobs::Engine, at: "/jobs"
  end

  root to: "pages#home"

  get "users/:id", to: "users#about", as: :about_user
  post "generate_match", to: "matches#generate", as: :generate_match
  # resources :recipes, only: :index
  resources :matches, only: [:index, :create, :show] do
    member do
      patch :save
      patch :unsave
    end
    collection do
      get :music_suggestions
      get :recipe_suggestions
      post :select_music
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"
end
