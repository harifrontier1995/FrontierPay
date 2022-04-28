Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users, only: [:create, :update]
  post '/send_otp_code', as: 'user_send_otp_code', to: 'users#send_code'
  #2factor
  post '/send_otp', to: 'users#send_otp'
  post '/verify_otp', to: 'users#verify_otp'
end
