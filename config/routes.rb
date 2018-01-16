Rails.application.routes.draw do
  root 'rooms#new'
  get 'login', to: 'rooms#new'
  post 'login', to: 'rooms#create'
  get 'logout', to: 'rooms#destroy'
  get 'room', to: 'rooms#view'

  resources :rooms, only: [:new, :create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
