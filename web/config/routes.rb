Rails.application.routes.draw do
  resources :appointments
  resources :professionals
  root to: 'application#home'
  resource :session, only: [:show, :create, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
