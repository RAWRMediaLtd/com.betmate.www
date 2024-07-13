module Sluggable
	extend ActiveSupport::Concern

	included do
		before_validation :generate_slug, on: :create
		validates :slug, presence: true
	end

	def generate_slug
		self.slug ||= name.parameterize if name.present?
	end
end


