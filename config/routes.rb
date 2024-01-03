Rails.application.routes.draw do
  root "top#index"

  resources :flights, only: [:index, :show]
end