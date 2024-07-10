class League < ApplicationRecord
	belongs_to :country
	has_many :seasons, dependent: :destroy

	def self.fetch_and_update_from_api
		response = HTTParty.get('https://v3.football.api-sports.io/leagues', headers: {
			'x-rapidapi-host' => ENV['API_SPORTS_URI'],
			'x-rapidapi-key'  => ENV['API_SPORTS_KEY']
			#'x-apisports-key' => ENV['API_SPORTS_KEY']
		})

		if response.success?
			remote_leagues = response.parsed_response['response']
			remote_leagues.each do |remote_league|
				league_data = remote_league['league']
				country_data = remote_league['country']
				seasons_data = remote_league['seasons']

				country = Country.find_or_create_by(name: country_data['name']) do |c|
					c.code = country_data['code']
					c.flag = country_data['flag']
				end


				
				league = League.find_or_initialize_by(id: league_data['id'])
				if league.new_record? || self.league_updated?(league, league_data)
					league.update!(
						id: league_data['id'],
						name: league_data['name'],
						type: league_data['code'],
						logo: league_data['flag'],
						country: country
					)
				end


				seasons_data.each do |season_data|
          season = league.seasons.find_or_initialize_by(year: season_data['year'])
				  season.update!(
				    start: season_data['start'],
				    end: season_data['end'],
				    current: season_data['current'],
				    coverage: season_data['coverage']
				  )
				end
			end
		end
	end

	def self.league_updated?(local_league, remote_league)
		local_league.name != remote_league['name'] ||
		local_league.type != remote_league['type'] ||
		local_league.flag != remote_league['flag']
	end

end
