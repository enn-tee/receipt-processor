Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :receipts, only: [ :show ] do
    get "points", on: :member
    collection do
      post "process", action: :create
    end
  end
end
