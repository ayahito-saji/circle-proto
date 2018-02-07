Rails.application.routes.draw do
  root "plays#edit"

  get "signup", to: "users#new"
  post "signup", to: "users#create"
  get "account", to: "users#show"
  get "account/setting", to: "users#edit"
  patch "account/setting", to: "users#update"
  delete "signout", to: "users#destroy"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  post "room/create", to: "rooms#create"
  get "room", to: "rooms#show"
  get "room/setting", to: "rooms#edit"
  patch "room/setting", to: "rooms#update"

  get "enter", to: "entrances#new"
  post "enter", to: "entrances#create"
  delete "exit", to: "entrances#destroy"

  get "enter", to: "entrances#show"

  get "play/", to: "plays#get"
  post "play/", to: "plays#post"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
