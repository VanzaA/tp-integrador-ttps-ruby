Rails.application.routes.draw do
  get 'download', action: :download, controller: 'professionals'
  resources :appointments
  resources :professionals
  root to: 'application#home'
  resource :session, only: [:show, :create, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
