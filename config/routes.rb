UserSignup::Application.routes.draw do

  # Named routes for signup and signin
  match 'signup' => 'users#new'
  match 'signin' => 'users#signin'

  get 'users/register/:uuid' => 'users#register'
  put 'users/update_for_register/:id' => 'users#update_for_register', :as => 'update_for_register'

  root :to => 'users#home'

  # We only need to create or update users
  resources :users, :except => [ :index, :show, :destroy ]

  # and create or destroy auth sessions
  resource :user_session, :only => [ :new, :create, :destroy ]


end
