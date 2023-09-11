Rails.application.routes.draw do
  root "sessions#show"
  resource :sessions, only: [:new, :create, :show, :destroy]
  resource :cookies, only: [:new, :create, :destroy] do
    get :new_third_party
  end
end
