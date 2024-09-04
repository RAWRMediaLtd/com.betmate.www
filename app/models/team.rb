class Team < ApplicationRecord
	has_many :home_fixtures, class_name: 'Fixture', foreign_key: 'home_team_id'
	has_many :away_fixtures, class_name: 'Fixture', foreign_key: 'away_team_id'

	has_many :fixture_events

	def self.find_or_initialize_and_update(team_data)
		team = Team.find_or_initialize_by(id: team_data['id'])
		if team.new_record? || team.team_updated?(team_data)
			team.assign_attributes(
				name: team_data['name'],
				code: team_data['code'],
				country: team_data['country'],
				founded: team_data['founded'],
				national: team_data['national'],
				logo: team_data['logo']
			)
			team.save!
		end
		team
	end

	def team_updated?(team_data)
		name != team_data['name'] ||
		code != team_data['code'] ||
		country != team_data['country'] ||
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
end
