Rails.application.routes.draw do
  get 'download', action: :download, controller: 'professionals'
  resources :appointments do
    collection do
      get 'export'
      post 'generate_file'
    end
    member do
      get 'reschedule'
      patch 'update_time'
    end
  end
  resources :professionals, only: [:index, :new, :edit, :destroy, :create, :update] do
    member do
      post 'cancel_all_appointments'
    end
  end
  root to: 'application#home'
  resource :session, only: [:show, :create, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
