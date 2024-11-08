namespace :backfill do
	desc "Backfill data for countries, leagues, seasons, fixtures, teams, and players"

	task fetch_data: :environment do
		#api_usage = ApiUsage.first_or_create(limit: ENV['API_LIMIT'].to_i, usage: 0)
		#api_limit = api_usage.limit - api_usage.usage

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

	task fetch_fixture_statistics: :environment do
		Fixture.includes(:season).find_each do |fixture|

			coverage = fixture.season.coverage

			unless coverage.dig('fixtures', 'statistics_fixtures')
				puts "Skipping fixture #{fixture.id} - #{fixture.slug} because it's not in the coverage"
				next
			end

			next if fixture.fixture_statistics.where('last_synced_at > ?', 1.year.ago).exists?

			puts "Fetching statistics for #{fixture.id} - #{fixture.slug}"
			FixtureStatistic.fetch_from_api(fixture: fixture.id)
		end
	end

	task fetch_fixture_events: :environment do
		Fixture.includes(:season).find_each do |fixture|
			coverage = fixture.season.coverage

			unless coverage.dig('fixtures', 'events')
				puts "Skipping fixture #{fixture.id} - #{fixture.slug} because it's not in the coverage"
				next
			end

			next if fixture.fixture_events.where('last_synced_at > ?', 1.year.ago).exists?

			puts "Fetching events for #{fixture.id} - #{fixture.slug}"
			FixtureEvent.fetch_from_api(fixture: fixture.id)
		end
	end

	task fetch_player_profiles: :environment do
		Player.all.each do |player|
			next if player.last_synced_at && player.last_synced_at > 5.minutes.ago

			puts "Fetching player profile for #{player.id}"

			# Fetch available seasons for the player
			player_seasons = Player.fetch_player_seasons_from_api(player.id)
			if player_seasons.nil? || player_seasons.empty?
				Rails.logger.info "No seasons found for player #{player.id}, setting seasons to #{player_seasons}"
				next
			end

			player_seasons.each do |season|
				puts "Fetching player profile for #{player.id} in season #{season}"
				remote_player_data = Player.fetch_from_api(id: player.id, season: season)

				if remote_player_data.nil? || remote_player_data.empty?
					Rails.logger.warn "No data returned for player #{player.id} in season #{season}"
					puts "No data returned for player #{player.id} in season #{season}"
					next
				end

				puts "Remote player data: #{remote_player_data.first['player']}"

				# Update player info
				player_data = remote_player_data.first['player']
				Player.find_or_initialize_and_update(player_data)

				# Update player statistics
				puts "Remote player statistics: #{remote_player_data.first['statistics']}"
				stat_data = remote_player_data.first['statistics']
				stat_data.each do |stat|
					PlayerStatistic.find_or_initialize_and_update(stat, player)
				end
			end

			# Update the players last synced at
			player.update(last_synced_at: Time.now)

		end
	end
end
