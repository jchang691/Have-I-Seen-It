HaveISeenIt::Application.routes.draw do
  resources :movies

  match '/', to: 'movies#index'
end
