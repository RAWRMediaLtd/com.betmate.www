namespace :backfill do
	desc "Backfill fixtures"

	task fetch_data: :environment do
		api_limit = ENV['API_LIMIT'].to_i

		Country.find_each do |country|
			Rails.logger.info "Processing country: #{country.name}"
			if country.leagues.empty?
				Rails.logger.info "Fetching leagues for #{country.name}"
				League.fetch_and_update_from_api(country)
				api_limit -= 1
				if api_limit <= 0
					break
				end
			end

			country.leagues.find_each do |league|
				Rails.logger.info "Processing league: #{league.name}"

				league.seasons.find_each do |season|
					Rails.logger.info "Delay"
					sleep(0.1)
					Rails.logger.info "Processing season: #{season.year}"
					if season.fixtures.empty?
						Rails.logger.info "Fetching fixtures for #{league.name} in #{season.year}"
						Fixture.fetch_and_update_from_api(season)
						api_limit -= 1

						if api_limit <= 0
							break
						end
					end
				end
				break if api_limit <= 0
			end
			break if api_limit <= 0
		end
	end
end
