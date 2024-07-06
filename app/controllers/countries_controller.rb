class CountriesController < ApplicationController
	def index
		@countries = Country.all
	end

	def refresh
		Country.fetch_and_update_from_api

		@countries = Country.all
		respond_to do |format|
			format.js {
				render partial: 'countries_list', locals: {
					countries: @countries
				}
			}
		end
	end
end
