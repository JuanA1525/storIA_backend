Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :users

      get "sign_up", to: "registration#new"
      post "sign_up", to: "registration#create"

      get "sign_in", to: "session#new"
      post "sign_in", to: "session#create"

      delete "logout", to: "session#destroy"

      get "global_numbers", to: "session#global_numbers"

      post "create_character", to: "character#create"

      get "all_characters", to: "character#user_characters" 

      post "update_character", to: "character#update"   
      
      delete "delete_character", to: "character#destroy"

    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
