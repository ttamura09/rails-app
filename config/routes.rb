Rails.application.routes.draw do
  root "top#index"

  resources :flights, only: [:index, :show]

  resource :session, only: [:create, :destroy]
  resource :account, only: [:show, :edit, :update, :new, :create, :destroy]
  resource :password, only: [:show, :edit, :update]
end