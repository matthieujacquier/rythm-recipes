Rails.application.routes.draw do
  devise_for :users
  root to: "matches#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post "generate_match", to: "matches#generate", as: :generate_match
  get "match_results", to: "matches#match_results", as: :match_results
  # Defines the root path route ("/")
  # root "posts#index"
  resources :matches, only: %i[index show create update destroy]
end
