Rails.application.routes.draw do
  root 'rooms#new'
  get 'login', to: 'rooms#new'
  post 'login', to: 'rooms#create'
  delete 'logout', to: 'rooms#exit'
  get 'room', to: 'rooms#view'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
