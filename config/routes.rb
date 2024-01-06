Rails.application.routes.draw do
  root "top#index"
  resources :flights, only: [:index, :show] do
    resources :bookings, only: [:new, :create]
  end

  resource :session, only: [:create, :destroy]
  resource :account, only: [:show, :edit, :update, :new, :create, :destroy] do
    resources :bookings, only: [:index, :show]
  end
  resource :password, only: [:show, :edit, :update]
end