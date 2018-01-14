Rails.application.routes.draw do
  root 'rooms#new'

  resources :rooms, only: [:new, :create, :destroy]
  resources :authentications, only: [:new, :create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
