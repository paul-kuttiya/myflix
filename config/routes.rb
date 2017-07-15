Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'
  get '/home', to: 'videos#index'
  
  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#register_with_invitation', 
  as: 'register_with_invitation'
  resources :users, only: [:create, :show]

  get '/sign_in', to: 'sessions#new'
  resources :sessions, only: [:create]
  get '/sign_out', to: 'sessions#destroy'

  resources :videos, only: [:show] do
    resources :reviews, only: [:create]

    collection do
      get "search"
    end
  end

  resources :categories, param: :name,  only: [:show]

  get "/my_queue", to: "queue_items#index"
  resources :queue_items, only: [:create, :destroy]
  post "/update_queue", to: "queue_items#update_queue"

  get "/people", to: "relationships#index"
  resources :relationships, only: [:create, :destroy]

  get "/forgot_password", to: "forgot_passwords#new"
  resources :forgot_passwords, only: [:create]

  get "/forgot_password_confirmation", to: "forgot_passwords#confirm"

  resources :password_resets, only: [:show, :create]

  get "/expired_token", to: "pages#expired_token"

  resources :invitations, only: [:new, :create]
end
