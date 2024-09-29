namespace :backfill do
	desc "Backfill data for countries, leagues, seasons, fixtures, teams, and players"

	task fetch_data: :environment do
		api_limit = ENV['API_LIMIT'].to_i

		Country.find_each do |country|
			Rails.logger.info "Processing country: #{country.name}"
			if country.leagues.empty?
				Rails.logger.info "Fetching leagues for #{country.name}"
				League.fetch_and_update_from_api(country)
				api_limit -= 1
				break if api_limit <= 0
			end

			country.leagues.find_each do |league|
				Rails.logger.info "Processing league: #{league.name}"

				league.seasons.find_each do |season|
					Rails.logger.info "Processing season: #{season.year}"
					
					if season.fixtures.empty?
						Rails.logger.info "Fetching fixtures for #{league.name} in #{season.year}"
						Fixture.fetch_and_update_from_api(season)
						api_limit -= 1
						break if api_limit <= 0
					end

					# Fetch teams for the season
					Rails.logger.info "Fetching teams for #{league.name} in #{season.year}"
					Team.fetch_and_update_from_api(league: league.id, season: season.year)
					api_limit -= 1
					break if api_limit <= 0

					# Fetch players for each team in the season
					season.fixtures.pluck(:home_team_id, :away_team_id).flatten.uniq.each do |team_id|
						Rails.logger.info "Fetching players for team ID: #{team_id} in #{season.year}"
						Player.fetch_and_update_from_api(team: team_id, season: season.year)
						api_limit -= 1
						break if api_limit <= 0
					end
				end
				break if api_limit <= 0
			end
			break if api_limit <= 0
		end
	end
end
