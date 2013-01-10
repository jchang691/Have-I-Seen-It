HaveISeenIt::Application.routes.draw do
  get "users/new"

  resources :users
  resources :actors
  resources :movies do
    get 'seen', :on => :collection
    get 'unseen', :on => :collection
    get 'add_to_library', :on => :collection
  end

  resources :sessions, only: [:new, :create, :destroy]

  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/search', to: 'search#search'

  root to: 'movies#index'
end
