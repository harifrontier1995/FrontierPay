Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: [:create, :update]
  post 'auth/login', to: 'authentication#authenticate'
  post 'auth/signup', to: 'users#send_code'
end
