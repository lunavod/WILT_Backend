Rails.application.routes.draw do
  resources :sessions
  resources :users
  resources :posts

  post 'sessions/', to: 'sessions#create'
  get 'users/:user_id/sessions/:session_id', to: 'sessions#show'
  match 'users/:user_id/sessions/:session_id', to: 'sessions#destroy', via: [:delete]
  get 'users/:user_id/sessions/', to: 'sessions#index'
  
  get 'users/:user_username/posts/', to: 'posts#user_index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
