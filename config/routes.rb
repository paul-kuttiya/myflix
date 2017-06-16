Myflix::Application.routes.draw do
  root to: 'pages#front'
  get '/home', to: 'videos#index'
  
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  resources :users, only: [:create]
  resources :sessions, only: [:create]
  get '/sign_out', to: 'sessions#destroy'

  resources :videos, only: [:show] do
    collection do
      get "search"
    end
  end

  resources :categories, param: :name,  only: [:show]

  get 'ui(/:action)', controller: 'ui'
end
