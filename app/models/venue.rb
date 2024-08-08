class Venue < ApplicationRecord
	include Sluggable

	has_many :fixtures

	def self.fetch_and_update_from_api(id = nil)
		puts "Fetch and update from api - Venues"

		url = "https://v3.football.api-sports.io/venues?id=#{id}"

		response = HTTParty.get(url, headers: {
			'x-rapidapi-host' => ENV['API_SPORTS_URI'],
			'x-rapidapi-key'  => ENV['API_SPORTS_KEY']
			#'x-apisports-key' => ENV['API_SPORTS_KEY']
		})

		puts response

		if response.success?
			remote_venues = response.parsed_response['response']
			remote_venues.each do |remote_venue|
				Venue.find_or_initialize_and_update(remote_venue)
			end
		end
	end

	def self.find_or_initialize_and_update(venue_data)
	  retries = 0

	  begin
      venue = Venue.find_by(id: venue_data['id'])

      unless venue
        venue = Venue.new(id: venue_data['id'])
      end

      Rails.logger.debug "Found or initialized venue: #{venue.id} - #{venue.name}"

      if venue.new_record? || venue.venue_updated?(venue_data)
        Rails.logger.debug "Updating venue: #{venue_data['name']}"

        venue.assign_attributes(
          name: venue_data['name'],
          address: venue_data['address'],
          city: venue_data['city'],
          #country: venue_data['country'],
          capacity: venue_data['capacity'],
          surface: venue_data['surface'],
          image: venue_data['image']
        )
        venue.slug ||= venue.name.parameterize
        venue.save!
      end
    rescue ActiveRecord::RecordNotUnique => e
      Rails.logger.warn "RecordNotUnique error: #{e.message}"
      if retries < 3
        retries += 1
        Rails.logger.warn "Retrying... (#{retries}/3)"
        sleep(0.5)
        retry
      else
        raise e
      end
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
