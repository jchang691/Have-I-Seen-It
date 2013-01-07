HaveISeenIt::Application.routes.draw do
  get "users/new"

  resources :movies
  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  root to: 'movies#index'
end
