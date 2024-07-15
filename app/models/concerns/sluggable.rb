module Sluggable
	extend ActiveSupport::Concern

	included do
		before_validation :generate_slug, on: :create
		validates :slug, presence: true
	end

	def generate_slug
		if self.is_a?(Season)
			self.slug = generate_season_slug
		else
			self.slug ||= name.parameterize if name.present?
		end
	end

	private

	def generate_season_slug
		start_year = self.start.year
		end_year = self.end.year

		if start_year == end_year
			start_year.to_s
		else
			"#{start_year}-#{end_year}"
		end
	end
end


