class Country < ApplicationRecord
	include Sluggable

	validates :name, presence: true
	validates :slug, uniqueness: true

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
						slug: normalized_name.parameterize
					)

					#country.generate_slug
					country.save!
				end
			end
		end
	end

	def self.create_or_update(country_data)
		normalized_name = normalize_name(country_data['name'])
		country = Country.find_or_initialize_by(slug: normalized_name.parameterize)

		if country.new_record?
			puts "Create country"
			country.assign_attributes(
				name: country_data['name'],
				code: country_data['code'],
				flag: country_data['flag'],
				slug: normalized_name.parameterize
			)
		else
			puts "Update country"
			country.assign_attributes(
				flag: country_data['flag']
			)
		end

		country.save!
		country

	end

	private

	def country_updated?(remote_country)
		flag != remote_country['flag']
	end

	def self.normalize_name(name)
		name.downcase.gsub(/[^a-z]/, '-')
	end

end
