Rails.application.routes.draw do
  root "top#index"
  resources :flights, only: [:index, :show] do
    resources :bookings, only: [:new, :create]
  end

  resource :session, only: [:new, :create, :destroy]
  resource :password, only: [:show, :edit, :update]
  resource :account, only: [:show, :edit, :update, :new, :create, :destroy] do
    resources :bookings, only: [:index, :show, :edit, :update]
  end
  namespace :admin do
    root "top#index"
    resource :session, only: [:new, :create, :destroy]
    resources :customers, only: [] do
      resources :bookings, only: [:update]
    end
  end

  resources :customers, only: [:index, :show, :destroy]
end