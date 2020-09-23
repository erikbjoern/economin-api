Rails.application.routes.draw do
  namespace :api do
    resources :budgets, only: [:create]
  end
end
