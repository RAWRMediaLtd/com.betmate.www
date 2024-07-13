class CountriesController < ApplicationController
	def index
		@countries = Country.all
	end

	def show
		@country = Country.find_by!(slug: params[:slug])
		@leagues = @country.leagues
	end

	def refresh
		Country.fetch_and_update_from_api

		@countries = Country.all
		respond_to do |format|
			format.html {
				render partial: 'countries_list', locals: {
					countries: @countries
				}
			}
		end
	end
end
