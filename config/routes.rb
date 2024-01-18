Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ja/ do
    root "top#index"
    resources :flights, only: [:index, :show] do
      resources :bookings, only: [:new, :create] do
        get "completed"
      end
    end

    resource :session, only: [:new, :create, :destroy]
    resource :password, only: [:show, :edit, :update]

    resource :account, only: [:show, :edit, :update, :new, :create, :destroy] do
      resources :bookings, only: [:index, :show, :destroy]
    end

    resources :booking_seat_flights, only: [] do
      resources :bookings, only: [:edit, :update] do
        get "check_in_completed"
      end
    end

    namespace :admin do
      root "top#index"
      resource :session, only: [:new, :create, :destroy]
      resources :customers, only: [] do
        resources :bookings, only: [:destroy]
      end
      resources :booking_seat_flights, only: [] do
        resources :bookings, only: [:update]
      end
    end
    resources :customers, only: [:index, :show, :destroy]

    namespace :air do
      root "top#index"
      resource :session, only: [:new, :create, :destroy]
      resources :flights, only: [:show, :update, :new, :create]
      resources :customers, only: [:show]
    end
  end
end