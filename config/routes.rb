Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: [:create, :update]
  post '/send_otp_code', as: 'user_send_otp_code', to: 'users#send_code'
end
