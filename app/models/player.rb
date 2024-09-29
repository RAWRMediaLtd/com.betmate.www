class Player < ApplicationRecord
  has_many :player_statistics, dependent: :destroy
  has_many :fixture_events

  def self.find_or_initialize_and_update(player)
    player = Player.find_or_initialize_by(id: player['id'])
    if player.new_record? || player.player_updated?(player)
      player.assign_attributes(
        name:          player['name'],
        firstname:     player['firstname'],
        lastname:      player['lastname'],
        age:           player['age'],
        birth_date:    player['birth'] ? player['birth']['date'] : nil,
        birth_place:   player['birth'] ? player['birth']['place'] : nil,
        birth_country: player['birth'] ? player['birth']['country'] : nil,
        nationality:   player['nationality'],
        height:        player['height'],
        weight:        player['weight'],
        injured:       player['injured'],
        photo:         player['photo']
      )
      player.save!

      if player['statistics'].is_a?(Array)
        player['statistics'].each do |stat_data|
          PlayerStatistic.find_or_initialize_and_update(stat_data, player)
        end
      else
        Rails.logger.info "No statistics found for player #{player['id']}"
      end
    end
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

  def self.fetch_and_update_from_api(team:, season:)
    url = "https://v3.football.api-sports.io/players?team=#{team}&season=#{season}"
    response = HTTParty.get(url, headers: {
      'x-apisports-key' => ENV['API_SPORTS_KEY']
    })

    if response.success?
      players_data = response.parsed_response['response']
      players_data.each do |player_data|
        Player.find_or_initialize_and_update(player_data['player'])
      end
    else
      Rails.logger.error "Error fetching players: #{response.message}"
    end
  end

  def player_updated?(player)
    name != player['name'] ||
    firstname != player['firstname'] ||
    lastname != player['lastname'] ||
    age != player['age'] ||
    birth_date != (player['birth'] && player['birth']['date']) ||
    birth_place != (player['birth'] && player['birth']['place']) ||
    birth_country != (player['birth'] && player['birth']['country']) ||
    nationality != player['nationality'] ||
    height != player['height'] ||
    weight != player['weight'] ||
    injured != player['injured'] ||
    photo != player['photo']
  end
end