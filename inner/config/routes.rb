Rails.application.routes.draw do
  root "sessions#show"
  resource :sessions, only: [:new, :create, :show, :destroy]
end
