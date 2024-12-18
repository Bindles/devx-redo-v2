Rails.application.routes.draw do
  get "conversations/index"
  get "conversations/show"
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # Nested profile routes under users
  resources :users, only: [ :edit, :update ] do  # only: [:edit, :update]
    resource :profile, only: [ :show, :edit, :update ]
    patch :update_username, on: :member
    patch :update_profile, on: :member
  end
  resources :feeds
  resources :friendships, only: [ :index, :create, :destroy ]
  # resources :friendships, path: 'friends', as: 'friends' #how to change name to friends with path

  resources :conversations, only: [ :index, :show, :create, :new ] do
    resources :messages, only: [ :create ]
    member do
      get :show_conversation
    end
  end
  resources :messages, only: [ :index ]


  resources :posts do
    resources :comments, only: [ :index, :create ] # , defaults: { commentable: 'Post' }
  end

  # resources :posts do
  #   member do
  #     get :comments
  #   end
  # end

  get  "ci", to: "conversations#index_all"
  root "posts#index"

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
