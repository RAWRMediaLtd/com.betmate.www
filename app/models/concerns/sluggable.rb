module Sluggable
	extend ActiveSupport::Concern

	included do
		before_validation :generate_slug, on: :create
		validates :slug, presence: true
	end

	def generate_slug
		if self.is_a?(Season)
			self.slug = generate_season_slug
		elsif self.is_a?(Fixture)
			self.slug = generate_fixture_slug
		else
			self.slug ||= generate_slug_from_name if self.name.present?
		end
	end

	private

	def generate_slug_from_name
		slug = name.to_slug.normalize.to_s
		# slug = transliterated_name.normalize.to_s
		slug.present? ? slug : SecureRandom.hex(8)
	end

	def generate_season_slug
		if self.start_date && self.end_date
			start_year = self.start_date.year
			end_year = self.end_date.year
		end

		if start_year == end_year
			start_year.to_s
		else
			"#{start_year}-#{end_year}"
		end
	end

	def generate_fixture_slug
		"#{self.home_team.name}-#{self.away_team.name}".parameterize
	end
end
