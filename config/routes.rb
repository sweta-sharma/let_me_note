Rails.application.routes.draw do
  post 'auth/register', to: 'users#register'
  post 'auth/login', to: 'users#login'

  get 'details', to: 'users#details'
  get 'users', to: 'users#index'

  resources :notes do
    put 'share', on: :member
    put 'unshare', on: :member
    put 'add_tag', on: :member
    put 'remove_tag', on: :member
  end

  get 'tags', to: 'tags#index'
  # get 'tags/:id/notes', to: 'tags#notes'
end
