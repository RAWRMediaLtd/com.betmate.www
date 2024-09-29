class Season < ApplicationRecord
	include Sluggable

	belongs_to :league
	has_many :fixtures, dependent: :destroy

	def self.find_or_initialize_and_update(season_data, league)
		season = league.seasons.find_or_initialize_by(year: season_data['year'])

		Rails.logger.debug "Found or initialized season: #{season.id} - #{season.year}"

		if season.new_record? || season.season_updated?(season_data)
			Rails.logger.debug "Updating season: #{season_data['year']}"

			season.assign_attributes(
				start_date: season_data['start'],
				end_date: season_data['end'],
				current: season_data['current'],
				coverage: season_data['coverage']
			)
			season.generate_slug
			season.save!
		end
		season
	end

	def season_updated?(remote_season)
		start_date != remote_season['start'] ||
		end_date != remote_season['end'] ||
		current != remote_season['current'] ||
		coverage != remote_season['coverage']
	end

	def self_end=(value)
		self[:end] = value
	end
end
