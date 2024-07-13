class Season < ApplicationRecord
	has_many :league_seasons
	has_many :leagues, through: :league_seasons

	def self.find_or_initialize_and_update(season_data, league)
		puts season_data
		season = league.seasons.find_or_initialize_by(year: season_data['year'])

		Rails.logger.debug "Found or initialized season: #{season.id} - #{season.year}"

		if season.new_record? || season.season_updated?(season_data)
			Rails.logger.debug "Updating season: #{season_data['year']}"

			season.assign_attributes(
				start: season_data['start'],
				self_end: season_data['end'],
				current: season_data['current'],
				coverage: season_data['coverage']
			)
			season.save!
		end
		season
	end

	def season_updated?(remote_season)
		start != remote_season['start'] ||
		self[:end] != remote_season['end'] ||
		current != remote_season['current'] ||
		coverage != remote_season['coverage']
	end

	def self_end=(value)
		self[:end] = value
	end
end
