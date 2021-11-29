Rails.application.routes.draw do
  get 'download', action: :download, controller: 'professionals'
  resources :appointments
  resources :professionals, only: [:index, :new, :edit, :destroy, :create, :update] do
    member do
      post 'cancel_all_appointments'
    end
  end
  root to: 'application#home'
  resource :session, only: [:show, :create, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
