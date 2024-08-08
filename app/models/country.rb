class Country < ApplicationRecord
	include Sluggable

	has_many :leagues

	def self.fetch_and_update_from_api
		response = HTTParty.get('https://v3.football.api-sports.io/countries', headers: {
			'x-rapidapi-host' => ENV['API_SPORTS_URI'],
			'x-rapidapi-key'  => ENV['API_SPORTS_KEY']
			#'x-apisports-key' => ENV['API_SPORTS_KEY']
		})

		puts response

		if response.success?
			remote_countries = response.parsed_response['response']

			remote_countries.each do |remote_country|
				country = Country.find_or_initialize_by(name: remote_country['name'])
				if country.new_record? || country.country_updated?(remote_country)
					country.update!(
						name: remote_country['name'],
						code: remote_country['code'],
						flag: remote_country['flag'],
					)

					country.generate_slug
					country.save!
				end
			end
		end
	end

	def self.find_or_initialize_and_update(country_data)
		country = Country.find_or_initialize_by(name: country_data['name'])

		puts country

		if country.new_record? || country.country_updated?(country_data)
			country.assign_attributes(
				name: country_data['name'],
				code: country_data['code'],
				flag: country_data['flag']
			)
			country.slug ||= country.name.parameterize
			country.save!(validate: false)
		end
		country
	end

	def country_updated?(remote_country)
		flag != remote_country['flag']
	end
end
