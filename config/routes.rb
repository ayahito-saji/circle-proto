Rails.application.routes.draw do
  root "entrances#show"

  get "signup", to: "users#new"
  post "signup", to: "users#create"
  get "account/setting", to: "users#edit"
  post "account/setting", to: "users#update"
  delete "signout", to: "users#destroy"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  get "account", to: "sessions#show"
  delete "logout", to: "sessions#destroy"

  post "room/create", to: "rooms#create"
  get "room/setting", to: "rooms#edit"
  post "room/setting", to: "rooms#update"

  get "enter", to: "entrances#new"
  post "enter", to: "entrances#create"
  get "room", to: "entrances#show"
  delete "exit", to: "entrances#destroy"

  get "enter", to: "entrances#show"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
