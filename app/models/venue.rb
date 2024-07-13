class Venue < ApplicationRecord
	include Sluggable

	def self.fetch_and_update_from_api(id = nil)
		url = "https://v3.football.api-spors.io/venues"

		response = HTTParty.get(url, headers: {
			'x-apisports-key' => ENV['API_SPORTS_KEY']
		})

		if response.success?
			remote_venues = response.parsed_response['response']
			remote_venues.each do |remote_venue|
				Venue.find_or_initialize_and_update(remote_venue)
			end
		end
	end

	def self.find_or_initialize_and_update(venue_data)
		venue = Venue.find_or_initialize_by(id: venue_data['id'])
		Rails.logger.debug "Found or initialized venue: #{venue.id} - #{venue.name}"

		if venue.new_record? || venue.venu_updated?(venue_data)
			Rails.logger.debug "Updating vvevnue: #{venue_data['name']}"

			venue.assign_attributes(
				name: venue_data['name'],
				address: venue_data['address'],
				city: venue_data['city'],
				country: venue_data['country'],
				capacity: venue_data['capacity'],
				surface: venue_data['surface'],
				image: venue_data['image']
			)
			venue.slug ||= venue.name.parameterize
			venue.save!
		end

		venue
	end

	def venue_updated?(remote_venue)
		name != remote_venue['name'] ||
		address != remote_venue['address'] ||
		city != remote_venue['country'] ||
		capacity != remote_venue['capacity'] ||
		surface != remote_venue['surface'] ||
		image != remote_venue['image']
	end
end
