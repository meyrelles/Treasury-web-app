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
  resources :usergroups
  resources :classifications
  resources :coinbags
  resources :currencies
  #Reset password
  get       '/password',        to: 'sessions#password'
  post      '/password',        to: 'sessions#reset_pass'
  get       '/password_reset',  to: 'sessions#reset_password'
  post      '/password_reset',  to: 'sessions#reset_password_post'

  #User Settings
  get       '/settings',        to: 'settings#index'
  post      '/settings',        to: 'settings#save'

  #Global Settings
  get       '/global_settings', to: 'global_settings#index'
  post      '/global_settings', to: 'global_settings#save'

  #Administration
  get       '/administrators',  to: 'administrators#index'
  post      '/administrators',  to: 'administrators#exec'

  get       '/login',           to: 'sessions#new'
  post      '/login',           to: 'sessions#create'
  delete    '/logout',          to: 'sessions#destroy'
  get       '/users',           to: 'users#index'
  post      '/users',           to: 'users#create'
  get       '/users/new',       to: 'users#new'
  get       '/users/:id/edit',  to: 'users#edit'
  get       '/users/:id',       to: 'users#show'
  patch     '/users/:id',       to: 'users#update'
  put       '/users/:id',       to: 'users#update'
  delete    '/users/:id',       to: 'users#destroy'

  # To approve transactions
  get       '/tr_statements/approvals',   to: 'tr_statements#approvals'
  post      '/approvals',   to: 'tr_statements#approvals_run'

  resources :tr_statements

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  #API ROUTES
  namespace 'api' do
    namespace 'v1' do
      resources :transactionin
      resources :transactionout
      resources :exchangein
      resources :exchangeout
    end
  end

  #REPORTS ROUTES
  get       '/treasuries',        to: 'treasuries#index'
  post      '/treasuries',        to: 'treasuries#filters'

  #MINERS MONITORING AND AUTOINSERT PAYMENTS
  get       '/miners',            to: 'miners#index'# via: :get
  put       '/miners',            to: 'miners#my_action'# via: :get
end
