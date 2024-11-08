class Season < ApplicationRecord
	include Sluggable

	belongs_to :league
	has_many :fixtures, dependent: :destroy
	has_many :teams, through: :fixtures
	has_many :players, through: :teams

	def self.fetch_and_update_from_api(league)
		api_client = ApiClient.new
		remote_seasons = api_client.fetch('leagues', seasons)

		remote_seasons.each do |remote_season|
			create_or_update(remote_season)
		end
	end

	def self.find_or_initialize_and_update(league, season_year)
		season_data = league.seasons.find_or_initialize_by(year: season_year)

		if season_data.new_record?
			Rails.logger.info "Creating new season: #{season_data['year']}"
			# puts "Creating new season: #{season_data['year']}"
			season_data.assign_attributes(
				start_date: season_data['start'],
				end_date: season_data['end'],
				current: season_data['current'],
				coverage: season_data['coverage']
			)
			season_data.generate_slug
		else
			Rails.logger.info "Updating season: #{season_data['year']}"
			# puts "Updating season: #{season_data['year']}"
			season_data.assign_attributes(
				coverage: season_data['coverage']
			)
		end
		season_data.save!
		season_data
	end
end
