class Season < ApplicationRecord
	has_many :league_seasons
	has_many :leagues, through: :league_seasons

	def self.fetch_and_update_from_api(league)
		response = HTTParty.get('https://v3.football.api-sports.io/leagues/seasons', headers: {
			'x-apisports-key' => ENV['API_SPORTS_KEY']
		})

		if response.success?
			remote_seasons = response.parsed_response['response']

			remote_seasons.each do |season_year|
				season = find_or_create_by(year: season_year)
				LeagueSeason.find_or_create_by(league: league, season: season)
			end
		end
	end
end
