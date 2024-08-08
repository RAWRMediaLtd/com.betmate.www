class Fixture < ApplicationRecord
	include Sluggable

	belongs_to :season
  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id'
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id'
  belongs_to :venue

  has_one :status, dependent: :destroy


	def self.find_or_initialize_and_update(fixture_data, season)
		fixture = Fixture.find_or_initialize_by(id: fixture_data['fixture']['id'])
		if fixture.new_record? || fixture.fixture_updated?(fixture_data)
			venue = Venue.find_or_initialize_and_update(fixture_data['fixture']['venue'])

			home_team = Team.find_or_initialize_and_update(fixture_data['teams']['home'])
			away_team = Team.find_or_initialize_and_update(fixture_data['teams']['away'])

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
				round: fixture_data['league']['round']
			)
			fixture.generate_slug
			fixture.save!

			Status.find_or_initialize_and_update(fixture_data['fixture']['status'], fixture)
		end
		fixture
	end

	def self.fetch_and_update_from_api(season)
		puts "SEASON: #{season}"
		league_id = season.league_id
		season_year = season.year

		url = "https://v3.football.api-sports.io/fixtures?league=#{league_id}&season=#{season_year}"
		response = HTTParty.get(url, headers: {
			'x-apisports-key' => ENV['API_SPORTS_KEY']
		})

		if response.success?
			remote_fixtures = response.parsed_response['response']
			remote_fixtures.each do |remote_fixture|
				Fixture.find_or_initialize_and_update(remote_fixture, season)
			end
		end
	end

	def self.fetch_from_api(params = {})
		league_id = season.league_id
		season_year = season.year

		url = "https://v3.football.api-sports.io/fixtures"
		response = HTTParty.get(url, {
			headers: {
				'x-apisports-key' => ENV['API_SPORTS_KEY']
			},
			query: params
		})

		if response.success?
			response.parsed_response['response']
		else
			puts "Error fetching fixtures: #{response.message}"
			[]
		end
	end

	def fixture_updated?(fixture_data)
		referee != fixture_data['fixture']['referee'] ||
		timezone != fixture_data['fixture']['timezone'] ||
		date != fixture_data['fixture']['date'] ||
		timestamp != fixture_data['fixture']['timestamp'] ||
		venue != venue ||
		status != status ||
		home_team != home_team ||
		away_team != away_team ||
		league != League.find_by(id: fixture_data['league']['id']) ||
		season != fixture_data['league']['season'] ||
		round != fixture_data['league']['round']
	end
end
