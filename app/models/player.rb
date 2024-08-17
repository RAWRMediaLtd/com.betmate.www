class Player < ApplicationRecord
  def self.find_or_initialize_and_update(player)
    player = Player.find_or_initialize_by(id: player['id'])
    if player.new_record? || player.player_updated?(player)
      player.assign_attributes(
        name:          player['name'],
        firstname:     player['firstname'],
        lastname:      player['lastname'],
        age:           player['age'],
        birth_date:    player['birth']['date'],
        birth_place:   player['birth']['place'],
        birth_country: player['birth']['country'],
        nationality:   player['nationality'],
        height:        player['height'],
        weight:        player['weight'],
        injured:       player['injured'],
        photo:         player['photo']
      )
      player.save!
  end

  def self.fetch_from_api(params = {})
		url = "https://v3.football.api-sports.io/players"
		response = HTTParty.get(url, {
			headers: {
				'x-apisports-key' => ENV['API_SPORTS_KEY']
			},
			query: params
		})

		if response.success?
			response.parsed_response['response']
		else
			puts "Error fetching fixtures: #{response.message}"
			[]
		end
	end

  def player_updated?(player)
    name != player['name'] ||
    firstname != player['firstname'] ||
    lastname != player['lastname'] ||
    age != player['age'] ||
    birth_date != player['birth']['date'] ||
    birth_place != player['birth']['place'] ||
    birth_country != player['birth']['country'] ||
    nationality != player['nationality'] ||
    height != player['height'] ||
    weight != player['weight'] ||
    injured != player['injured'] ||
    photo != player['photo']
  end
end
