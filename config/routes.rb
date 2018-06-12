Rails.application.routes.draw do
  controller :main do
    root :to => "main#home"
    get  '/help',               to: 'main#help'
    get  '/about',              to: 'main#about'
    get  '/contact',            to: 'main#contact'
  end
  get       '/signup',          to: 'users#new'
  post      '/signup',          to: 'users#create'
  get       '/signup',          to: 'users#edit'
  patch     '/signup',          to: 'users#update'
  resources :main
  resources :users
  resources :classifications
  resources :coinbags
  resources :currencies
  get       '/login',           to: 'sessions#new'
  post      '/login',           to: 'sessions#create'
  delete    '/logout',          to: 'sessions#destroy'
  get       '/users',           to: 'users#index'
  post      '/users',           to: 'users#creat'
  get       '/users/new',       to: 'users#new'
  get       '/users/:id/edit',  to: 'users#edit'
  get       '/users/:id',       to: 'users#show'
  patch     '/users/:id',       to: 'users#update'
  put       '/users/:id',       to: 'users#update'
  delete    '/users/:id',       to: 'users#destroy'
  resources :tr_statements
  # To list coinbags per user
  get "/treasury" => "coinbags#user_coinbags"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
end
