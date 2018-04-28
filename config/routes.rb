Rails.application.routes.draw do
  resources :orders
  resources :reasons
  resources :coinbags
  resources :currencies
  get 'users2/new'
  resources :users
  get 'users/new'
  resources :tr_statements
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
end
