Rails.application.routes.draw do
  get '/home' => 'static_pages#home'

  get '/profile' => 'static_pages#profile'

  get '/settings' => 'static_pages#setting'

  # get '/messages' => 'static_pages#messages'
  get '/messages' => 'conversations#index'

  get '/connections' => 'static_pages#connections'

  get '/search' => 'static_pages#search'

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }, :skip => [:sessions]

  root 'home#index'

  devise_scope :user do
    get '/login' => "devise/sessions#new", as: 'new_user_session'
    get '/logout' => "devise/sessions#destroy", as: 'destroy_user_session'
    post '/login' => "devise/sessions#create", as: 'user_session'
  end

  resources :user_admin

  get '/admin' => 'user_admin#index'
  get '/admin/edit_user/:id' => 'user_admin#edit', as: 'admin_edit_user'
  patch '/admin/edit_user/:id' => 'user_admin#update', as: 'user_admin_user'

  get '/admin/new_user' => 'user_admin#new', as: 'admin_new_user'
  post '/admin/new_user' => 'user_admin#create', as: 'user_admin_users'


  resources :conversations, only: [:index, :show, :destroy]
  resources :messages, only: [:new, :create]



end
