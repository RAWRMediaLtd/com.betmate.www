class Fixture < ApplicationRecord
	include Sluggable

	belongs_to :season
  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id'
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id'
  belongs_to :venue, optional: true

	has_one :period, class_name: 'FixturePeriod', dependent: :destroy
	has_one :status, class_name: 'FixtureStatus', dependent: :destroy
	has_one :score, class_name: 'FixtureScore', dependent: :destroy

	has_many :fixture_events, dependent: :destroy
	has_many :fixture_statistics, dependent: :destroy


	def self.find_or_initialize_and_update(fixture_data, season)
		puts "Adding Fixture: #{fixture_data['fixture']['id']}"
		puts "#{fixture_data['teams']['home']['name']} vs #{fixture_data['teams']['away']['name']}"

		fixture = Fixture.find_or_initialize_by(id: fixture_data['fixture']['id'])

		if fixture.new_record? || fixture.fixture_updated?(fixture_data)
			venue = nil
			winner = nil

			if fixture_data['fixture']['venue'].present? && fixture_data['fixture']['venue']['name'].present?
				# puts "Venue: #{fixture_data['fixture']['venue']}"
				venue = Venue.find_or_create_by(id: fixture_data['fixture']['venue']['id'])
			end

			home_team = Team.find_or_initialize_and_update(fixture_data['teams']['home'])
			away_team = Team.find_or_initialize_and_update(fixture_data['teams']['away'])

			if fixture_data['teams']['home']
				if fixture_data['teams']['home']['winner'] == true
					winner = "home"
				elsif fixture_data['teams']['away']['winner'] == true
					winner = "away"
				end
			end

			fixture.assign_attributes(
				referee: fixture_data['fixture']['referee'],
				timezone: fixture_data['fixture']['timezone'],
				date: fixture_data['fixture']['date'],
				timestamp: fixture_data['fixture']['timestamp'],
				venue: venue,
				home_team: home_team,
				away_team: away_team,
				#league: League.find_by(id: fixture_data['league']['id']),
				season: season,
				round: fixture_data['league']['round'],
				winner: winner,
				last_synced_at: Time.now
			)
			fixture.generate_slug
			fixture.save!

			# puts "Saved Fixture: #{fixture.id} - #{fixture.home_team.name} vs #{fixture.away_team.name}"

			if fixture_data['fixture']['periods'].present?
				FixturePeriod.find_or_initialize_and_update(fixture_data['fixture']['periods'], fixture)
			end

			if fixture_data['fixture']['status'].present?
				FixtureStatus.find_or_initialize_and_update(fixture_data['fixture']['status'], fixture)
			end

			FixtureScore.find_or_initialize_and_update(fixture_data['score'], fixture)
		end
		fixture
	end

	def self.fetch_and_update_from_api(params = {})
		api_client = ApiClient.new

		remote_fixtures = api_client.fetch('fixtures', params)
		season = Season.find_by(year: params[:season])

		if remote_fixtures.present?

			Rails.logger.info("Found #{remote_fixtures.count} fixtures")
			remote_fixtures.each do |remote_fixture|
				Fixture.find_or_initialize_and_update(remote_fixture, season)
			end
		end
	end

	def fixture_updated?(fixture_data)
		referee != fixture_data['fixture']['referee'] ||
		timezone != fixture_data['fixture']['timezone'] ||
		date != fixture_data['fixture']['date'] ||
		timestamp != fixture_data['fixture']['timestamp'] ||
		venue != venue ||
		home_team != home_team ||
		away_team != away_team ||
		season != fixture_data['league']['season'] ||
		round != fixture_data['league']['round']
	end
end
