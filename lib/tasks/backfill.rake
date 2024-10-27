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
end
