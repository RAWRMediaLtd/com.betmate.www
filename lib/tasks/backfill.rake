namespace :backfill do
	desc "Backfill data for countries, leagues, seasons, fixtures, teams, and players"

	task fetch_data: :environment do
		api_usage = ApiUsage.first_or_create(limit: ENV['API_LIMIT'].to_i, usage: 0)
		api_limit = api_usage.limit - api_usage.usage

		League.all.each do |league|
			next if league.last_synced_at && league.last_synced_at > 1.day.ago

			puts "Fetching fixtures for #{league.name}"
			league.seasons.each do |season|
				puts "Fetching fixtures for #{season.year}"

				next if season.fixtures.where('last_synced_at > ?', 2.day.ago).exists?

				Fixture.fetch_and_update_from_api(league: league.id, season: season.year)
			end

			league.update(last_synced_at: Time.now)
		end
	end

	task team_seasons: :environment do
		Team.all.each do |team|
			puts "Fetching seasons for #{team.name}"
			team.seasons.fetch_from_api
		end
	end
end
