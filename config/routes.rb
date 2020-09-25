Rails.application.routes.draw do
  namespace :api do
    resources :budgets, only: %i[index create]
  end
end
