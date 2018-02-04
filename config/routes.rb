Rails.application.routes.draw do
  root "rooms#show"

  get "signup", to: "users#new"
  post "signup", to: "users#create"
  get "account", to: "users#show"
  get "account/setting", to: "users#edit"
  post "account/setting", to: "users#update"
  delete "signout", to: "users#destroy"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  post "room/create", to: "rooms#create"
  get "room", to: "rooms#show"
  get "room/setting", to: "rooms#edit"
  post "room/setting", to: "rooms#update"

  get "enter", to: "entrances#new"
  post "enter", to: "entrances#create"
  delete "exit", to: "entrances#destroy"

  get "enter", to: "entrances#show"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
