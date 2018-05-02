Rails.application.routes.draw do
  get 'sessions/new'
  resources :classifications
  resources :coinbags
  resources :currencies
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  get 'users/new'
  resources :tr_statements
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
end
