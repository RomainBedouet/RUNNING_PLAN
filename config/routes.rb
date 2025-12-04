Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "profile", to: "users#profile"
  get "profile/edit", to: "users#edit"
  patch "profile", to: "users#update"

  resources :objectifs, only: [:index, :show, :create]
  resources :user, only: [:update]
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check


  # Defines the root path route ("/")
  # root "posts#index"
  get "chat", to: "chat#create"
  resource :running_chat, only: [:show, :create]


end
