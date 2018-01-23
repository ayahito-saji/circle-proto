Rails.application.routes.draw do
  root "sessions#show"

  get "signup", to: "users#new"
  post "signup", to: "users#create"
  delete "signout", to: "users#destroy"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  get "account", to: "sessions#show"
  delete "logout", to: "sessions#destroy"

  post "create_room", to: "rooms#create"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
