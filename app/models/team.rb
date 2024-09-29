class Team < ApplicationRecord
	belongs_to :country

	has_many :home_fixtures, class_name: 'Fixture', foreign_key: 'home_team_id'
	has_many :away_fixtures, class_name: 'Fixture', foreign_key: 'away_team_id'

	has_many :fixture_events


	def self.find_or_initialize_and_update(team_data)

		puts "TEAM: #{team_data['name']}"
		puts "COUNTRY: #{team_data['country']}"

		team = Team.find_or_initialize_by(id: team_data['id'])
		if team.new_record? || team.team_updated?(team_data)

			country = nil
			if team_data['country'].present?
				country = Country.find_or_create_by(name: team_data['country'])
			end

			team.assign_attributes(
				name: team_data['name'],
				code: team_data['code'],
				country: country,
				founded: team_data['founded'],
				national: team_data['national'],
				logo: team_data['logo']
			)
			team.save(validate: false)
		end
		team
	end

	def team_updated?(team_data)
		name != team_data['name'] ||
		code != team_data['code'] ||
		(country&.id != team_data['country']) ||
		founded != team_data['founded'] ||
		national != team_data['national'] ||
		logo != team_data['logo']
	end

	def self.fetch_and_update_from_api(id = nil)
		url = "https://v3.football.api-sports.io/teams?id=#{id}"
		response = HTTParty.get(url, headers: {
			'x-apisports-key' => ENV['API_SPORTS_KEY']
		})

		if response.success?
			remote_teams = response.parsed_response['response']

			remote_teams.each do |remote_team|
				Team.find_or_initialize_and_update(remote_team)
			end
		end
	end

	def self.fetch_and_update_from_api(league:, season:)
		url = "https://v3.football.api-sports.io/teams?league=#{league}&season=#{season}"
		response = HTTParty.get(url, headers: {
			'x-apisports-key' => ENV['API_SPORTS_KEY']
		})

		if response.success?
			teams_data = response.parsed_response['response']
			teams_data.each do |team_data|
				Team.find_or_initialize_and_update(team_data['team'])
			end
		else
			Rails.logger.error "Error fetching teams: #{response.message}"
		end
	end
end
