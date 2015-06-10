Rails.application.routes.draw do
  get '/home' => 'static_pages#home'

  get '/profile' => 'static_pages#profile'

  get '/settings' => 'static_pages#setting'

  get '/messages' => 'conversations#index'

  get '/connections' => 'friendships#index'

  get '/search' => 'static_pages#search'


  get '/profile/:id' => 'static_pages#show_profile', as: 'user_profile'

  get '/recipients' => 'messages#recipients', as: 'recipients'


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

  get '/admin/content' => 'static_pages#content', as: 'admin_content'
  get '/admin/upload' => 'user_admin#upload', as: 'admin_upload'
  post '/admin/upload' => 'user_admin#uploadFile', as: 'admin_upload_file'

  get '/admin/delete/:id' => 'user_admin#destroy', as: 'admin_delete_user'


  resources :conversations, only: [:index, :show, :destroy] do
    member do
      post :reply
    end
  end

  resources :messages, only: [:new, :create]

  get '/messages/new/:id' => 'messages#msg_user', as: 'message_user'
  get '/admin/messages/new/all' => 'messages#msg_all_users', as: 'message_all_users'

  resources :friendships do
    member do
      put :accept
      delete :block
    end
  end

  resources :content

  post '/admin/content/new' => 'contents#create', as: 'content_contents'
  post '/admin/content/layout' => 'contents#layout_edit', as: 'edit_layout_contents'




end
