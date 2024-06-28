Rails.application.routes.draw do
  get 'leagues/index'
  get 'leagues/show'
  root 'countries#index'

  #get 'countries/index'
  get 'countries/refresh', to: 'countries#refresh'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
