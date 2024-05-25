Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :users
      #Registration
      get "sign_up", to: "registration#new"
      post "sign_up", to: "registration#create"
      #Session
      get "sign_in", to: "session#new"
      post "sign_in", to: "session#create"
      delete "logout", to: "session#destroy"
      get "global_numbers", to: "session#global_numbers"
      #Character
      post "create_character", to: "character#create"
      get "all_characters", to: "character#index" 
      get "character", to: "character#show" 
      post "update_character", to: "character#update"   
      delete "delete_character", to: "character#destroy"
      #Story
      post "create_story", to: "story#create"
      get "all_story", to: "story#index" 
      get "story", to: "story#show" 
      post "update_story", to: "story#update"   
      delete "delete_story", to: "story#destroy"
      #Review
      post "create_review", to: "review#create"
      put "update_review", to: "review#edit"
      detele "delete_review", to: "review#delete"
      get "see_review", to: "review#see"
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
