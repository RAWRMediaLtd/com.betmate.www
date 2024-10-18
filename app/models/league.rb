class League < ApplicationRecord
	include Sluggable

	belongs_to :country
	has_many :seasons, dependent: :destroy
	has_many :teams
	has_many :fixtures

	def self.fetch_and_update_from_api(country = nil)
		api_client = ApiClient.new
		remote_leagues = api_client.fetch('leagues')

		remote_leagues.each do |remote_league|

			league_data = remote_league['league']
			country_data = remote_league['country']
			seasons_data = remote_league['seasons']

			country = Country.create_or_update(country_data)
			league = League.create_or_update(league_data, country)

			seasons_data.each do |season_data|
				Season.create_or_update(season_data, league)
			end
		end
	end

	def self.create_or_update(league_data, country)
		league = country.leagues.find_or_initialize_by(id: league_data['id'])

		if league.new_record?
			Rails.logger.info "Creating new league: #{league_data['name']}"
			# puts "Creating new league: #{league_data['name']}"
			league.assign_attributes(
				name: league_data['name'],
				league_type: league_data['type'],
				logo: league_data['logo'],
				country: country
			)
			league.slug ||= league.name.parameterize
 		else
			Rails.logger.info "Updating league: #{league_data['name']}"
			#	puts "Updating league: #{league_data['name']}"
			league.assign_attributes(
				logo: league_data['logo']
			)
		end

		league.save!
		# puts "League saved: #{league.id} - #{league.name}"
		league
	end
end
