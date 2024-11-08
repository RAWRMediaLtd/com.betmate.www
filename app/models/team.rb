class Team < ApplicationRecord
	belongs_to :country

	has_many :home_fixtures, class_name: 'Fixture', foreign_key: 'home_team_id'
	has_many :away_fixtures, class_name: 'Fixture', foreign_key: 'away_team_id'

	has_many :fixture_events


	def self.find_or_initialize_and_update(team_data)
		puts "Team data: #{team_data['name']}"

		team = Team.find_or_initialize_by(id: team_data['id'])

		puts "Country: #{team_data['country']}"

		if team_data['country'].present?
			country = Country.find_or_create_by(name: team_data['country'])
		else
			country = nil
		end

		if team.new_record?
			Rails.logger.info "Creating new team: #{team_data['name']}"
			puts "Creating new team: #{team_data['name']}"
			team.assign_attributes(
				name: team_data['name'],
				code: team_data['code'],
				country: country,
				founded: team_data['founded'],
				national: team_data['national'],
				logo: team_data['logo'],
				slug: team_data['name'].to_slug.normalize.to_s
			)
		else
			Rails.logger.info "Updating team: #{team_data['name']}"
			# puts "Updating team: #{team_data['name']}"
			team.assign_attributes(
				code: team_data['code'],
				country: country,
				founded: team_data['founded'],
				national: team_data['national'],
				logo: team_data['logo']
			)
		end
		team.save!
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

	def self.fetch_and_update_from_api(params = {})
		api_client = ApiClient.new
		remote_teams = api_client.fetch('teams', params)

		remote_teams.each do |remote_team|
			team_data = remote_team['team']
			Team.find_or_initialize_and_update(team_data)
		end
	end
end
