class Venue < ApplicationRecord
	include Sluggable

	has_many :fixtures

	def self.fetch_and_update_from_api(params = {})
		#puts "Fetch and update from api - Venues"

		#url = "https://v3.football.api-sports.io/venues?id=#{id}"

		#response = HTTParty.get(url, headers: {
		#	'x-rapidapi-host' => ENV['API_SPORTS_URI'],
		#	'x-rapidapi-key'  => ENV['API_SPORTS_KEY']
			#'x-apisports-key' => ENV['API_SPORTS_KEY']
		#})

#		puts response

#		if response.success?
#			remote_venues = response.parsed_response['response']
#			remote_venues.each do |remote_venue|
#				Venue.find_or_initialize_and_update(remote_venue)
#			end
#		end

		api_client = ApiClient.new

		remote_venues = api_client.fetch('venues', params)
		if remote_venues.present?
			remote_venues.each do |remote_venue|
				Venue.create_or_update(remote_venue)
			end
		end
	end

	def self.create_or_update(venue_data)
    venue = Venue.find_or_initialize_by(id: venue_data['id'])

		if venue.new_record?
			Rails.logger.debug "Creating venue: #{venue_data['name']}"
			puts "Creating venue: #{venue_data['name']}"

			venue.assign_attributes(
				name: sanitize_name(venue_data['name']),
				address: venue_data['address'],
				city: venue_data['city'],
				# country: country,
				capacity: venue_data['capacity'],
				surface: venue_data['surface'],
				image: venue_data['image'],
				slug: name.to_slug.normalize.to_s,
				last_synced_at: Time.now
			)
			# venue.slug ||= venue.name.parameterize
		else
			Rails.logger.debug "Updating venue: #{venue_data['name']}"
			#puts "Updating venue: #{venue_data['name']}"

			venue.assign_attributes(
				address: venue_data['address'],
				city: venue_data['city'],
				capacity: venue_data['capacity'],
				surface: venue_data['surface'],
				image: venue_data['image'],
				last_synced_at: Time.now
			)
		end

		venue.save!
    venue
	end

	private
	def self.sanitize_name(name)
		name.gsub!(/[^0-9A-Za-z]/, '-')
	end
end
