Rails.application.routes.draw do
  get '/home' => 'static_pages#home'

  get '/profile' => 'static_pages#profile'

  get '/settings' => 'static_pages#setting'

  get '/messages' => 'static_pages#messages'

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

end
