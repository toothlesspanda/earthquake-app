Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"

  devise_for :users

  # Defines the root path route ("/")
  root to: "home#index"
  resources :earthquakes, only: [ :index, :show ]

  constraints subdomain: "api" do
    namespace :api do
      namespace :v1 do
        # Your API routes go here
        resources :earthquakes, only: [ :index, :show ]
      end
    end
  end
end
