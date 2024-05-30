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
      get "get_character", to: "character#show" 
      get "act_like", to: "character#act_like"
      put "update_character", to: "character#update"
      delete "delete_character", to: "character#destroy"
      #Story
      post "create_story", to: "story#create"
      get "all_story", to: "story#index" 
      get "story", to: "story#show" 
      put "update_story", to: "story#update"   
      delete "delete_story", to: "story#destroy"
      get "feed", to: "story#feed"
      #Review
      post "create_review", to: "review#create"
      put "update_review", to: "review#edit"
      delete "delete_review", to: "review#destroy"
      get "see_review", to: "review#see"
      #Report
      post "create_report", to: "report#create"
      delete "delete_report", to: "report#destroy"
      get "report_review", to: "report#index_by_review"
      get "report_story", to: "report#index_by_story"
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
