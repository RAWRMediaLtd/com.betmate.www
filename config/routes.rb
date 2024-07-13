Rails.application.routes.draw do

	resources :countries, param: :slug, only: [:index, :show] do
		collection do
			get 'refresh'
		end

		resources :leagues, param: :slug, path: '', only: [:index, :show] do
			collection do
				get 'refresh'
			end

			resources :seasons, param: :slug, only: [:index, :show] do
				collection do
					get 'refresh'
				end
			end
		end
	end

	resources :leagues, only: [:index, :show] do
		collection do
			get 'refresh'
		end
	end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
