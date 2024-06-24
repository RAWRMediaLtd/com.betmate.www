class CountriesController < ApplicationController
	def index
		@countries = Country.all
	end

	def refresh
		fetch_and_update_countries
		@countries = Country.all
		respond_to do |format|
			format.js {
				render partial: 'countries_list', locals: {
					countries: @countries
				}
			}
		end
	end

	private

	def fetch_and_update_countries
		response = HTTParty.get('https://v3.football.api-sports.io/countries', headers: {
			#'x-rapidapi-host' => ENV['API_SPORTS_URL'],
			#'x-rapidapi-key'  => ENV['API_SPORTS_KEY']
			'x-apisports-key' => ENV['API_SPORTS_KEY']
		})

		puts response

		if response.success?
			remote_countries = response.parsed_response['response']

			remote_countries.each do |remote_country|
				country = Country.find_or_initialize_by(code: remote_country['code'])
				if country.new_record? || country_updated?(country, remote_country)
					country.update!(
						name: remote_country['name'],
						code: remote_country['code'],
						flag: remote_country['flag']
					)
				end
			end
		end
	end

	def country_updated?(local_country, remote_country)
		local_country.name != remote_country['name'] || local_country.flag != remote_country['flag']
	end
end
