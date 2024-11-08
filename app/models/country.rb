class Country < ApplicationRecord
	include Sluggable

	validates :name, presence: true
	validates :slug, uniqueness: true

	has_many :leagues

	def self.fetch_and_update_from_api
		api_client = ApiClient.new
		remote_countries = api_client.fetch('countries')

		remote_countries.each do |remote_country|
			create_or_update(remote_country)
		end
	end

	def self.create_or_update(country_data)
		normalized_name = normalize_name(country_data['name'])
		slug = normalized_name.parameterize
		country = Country.find_or_initialize_by(slug: slug)

		if country.new_record?
			puts "Create country"
			country.assign_attributes(
				name: country_data['name'],
				code: country_data['code'],
				flag: country_data['flag'],
				slug: slug
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
