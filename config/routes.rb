Rails.application.routes.draw do
  authenticated :user do
    root to: 'tasks#index', as: :authenticated_root, via: [:get]
  end

  root to: "home#index"

  devise_for :users

  resources :tasks

  resources :attachments, only: :show

  namespace :api do
    resources :tasks
    resources :attachments
  end


  get "/healthcheck", to: "healthcheck#index"
end
