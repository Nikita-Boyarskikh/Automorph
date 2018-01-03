Rails.application.routes.draw do
  get 'db/cache'
  get 'db/users'

  resources :users, only: [:index, :create, :show, :edit, :update, :destroy]

  get '/automorph' => 'automorph#index'
  get 'automorph/result'

  get '/signup' => 'users#new'
  get '/signin' => 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  post '/sessions/create'

  root 'sessions#new'
end
