class League < ApplicationRecord
	include Sluggable

	belongs_to :country
	has_many :seasons, dependent: :destroy

	def self.fetch_and_update_from_api(country = nil)

		url = country ? "https://v3.football.api-sports.io/leagues?country=#{country.name}": "https://v3.football.api-sports.io/leagues"
		response = HTTParty.get(url, headers: {
			'x-apisports-key' => ENV['API_SPORTS_KEY']
		})

		if response.success?
			remote_leagues = response.parsed_response['response']

			remote_leagues.each do |remote_league|
				league_data = remote_league['league']
				country_data = remote_league['country']
				seasons_data = remote_league['seasons']

				country = Country.find_or_initialize_and_update(country_data)
				league = League.find_or_initialize_and_update(league_data, country)

        seasons_data.each do |season_data|
          Season.find_or_initialize_and_update(season_data, league)
        end

			end
		end
	end

	def self.find_or_initialize_and_update(league_data, country)
		league = country.leagues.find_or_initialize_by(id: league_data['id'])

		Rails.logger.debug "Found or initialized league: #{league.id} - #{league.name}"

		if league.new_record? || league.league_updated?(league_data)

			Rails.logger.debug "Updating league: #{league_data['name']}"

			league.assign_attributes(
				name: league_data['name'],
				league_type: league_data['type'],
				logo: league_data['logo'],
				country: country
			)
			league.slug ||= league.name.parameterize
			league.save!
		end

		league
	end

	def league_updated?(remote_league)
		name != remote_league['name'] ||
		league_type != remote_league['type'] ||
		logo != remote_league['logo']
	end
end
