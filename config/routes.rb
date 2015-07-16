Rails.application.routes.draw do
  get '/home' => 'static_pages#home'

  get '/profile' => 'static_pages#profile'

  get '/settings' => 'static_pages#setting'

  get '/messages' => 'conversations#index'

  get '/connections' => 'friendships#index'

  get '/unauthorized' => 'static_pages#unauth'


  get '/profile/:id' => 'static_pages#show_profile', as: 'user_profile'


  get '/recipients' => 'messages#recipients', as: 'recipients'
  get '/allrecipients' => 'messages#admin_recipients', as: 'admin_recipients'


  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }, :skip => [:sessions]

  root 'home#index'

  devise_scope :user do
    get '/login' => "devise/sessions#new", as: 'new_user_session'
    get '/logout' => "devise/sessions#destroy", as: 'destroy_user_session'
    post '/login' => "devise/sessions#create", as: 'user_session'
  end

  resources :user_admin

  get '/admin' => 'user_admin#index'
  get '/admin/get_users/:type' => 'user_admin#get_users'
  get '/admin/users/autocomplete' => 'user_admin#autocomplete_users'
  get '/admin/users/search' => 'user_admin#search_users'

  get '/admin/edit_user/:id' => 'user_admin#edit', as: 'admin_edit_user'
  patch '/admin/edit_user/:id' => 'user_admin#update', as: 'user_admin_user'

  get '/admin/new_user' => 'user_admin#new', as: 'admin_new_user'
  post '/admin/new_user' => 'user_admin#create', as: 'user_admin_users'

  get '/admin/content' => 'static_pages#content', as: 'admin_content'
  get '/admin/upload' => 'user_admin#upload', as: 'admin_upload'
  post '/admin/upload' => 'user_admin#uploadFile', as: 'admin_upload_file'

  get '/admin/delete/:id' => 'user_admin#destroy', as: 'admin_delete_user'

  get '/user/edit' => 'user_admin#edit_self', as: 'edit_profile'




  resources :conversations, only: [:index, :show, :destroy] do
    member do
      post :reply
      post :delete
    end
  end

  get '/conversations/:type' => 'conversation#sort_conversations'

  resources :messages, only: [:new, :create]

  get '/messages/new/:id' => 'messages#msg_user', as: 'message_user'
  get '/admin/messages/new/all' => 'messages#msg_all_users', as: 'message_all_users'

  resources :friendships do
    member do
      put :accept
      delete :block
      post :create, as: 'create'
    end
  end

  get '/connections/all/:type' => 'friendships#filter', as: 'filter'

  resources :content

  patch '/admin/content/#id' => 'contents#update', as: 'content_content'

  patch '/admin/content/layout/#id' => 'contents#layout_edit', as: 'edit_layout_content'


  # resources :search
  get '/search/results' => 'searchs#search_results'
  get '/search'  => 'searchs#new_search'

  post '/search/new' => 'searchs#search', as: 'search_searches'
  patch '/search/update/:id' => 'searchs#update_search', as: 'search_search'
  post '/search/add_favorite' => 'searchs#save_favorite_search', as: 'favorite_search'
  get '/search/delete_favorite/:id' => 'searchs#delete_favorite_search', as: 'search_delete'


end
