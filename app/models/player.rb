class Player < ApplicationRecord
  has_many :player_statistics, dependent: :destroy
  has_many :fixture_events

  def self.find_or_initialize_and_update(player)
    puts "Find or initialize and update Player: #{player['name']}"

    player_data = Player.find_or_initialize_by(id: player['id'])

    if player_data.new_record? || player_data.player_updated?(player)
      puts "Updating player: #{player['id']} - #{player['name']}"
      player_data.assign_attributes(
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
        photo:         player['photo'],
        last_synced_at: Time.now
      )
      player_data.save!
    end
  end

  def self.fetch_player_seasons_from_api(player_id)
    api_client = ApiClient.new
    remote_player_seasons = api_client.fetch('players/seasons', { player: player_id })

    if remote_player_seasons.nil? || remote_player_seasons.empty?
      Rails.logger.info "No seasons found for player #{player_id}"
      return []
    end
    remote_player_seasons
  end

  def self.fetch_from_api(params = {})
    api_client = ApiClient.new
    remote_player = api_client.fetch('players', params)



    if remote_player.empty?
      Rails.logger.info "No player found for #{params[:player]}"
      puts "No player found for #{params[:player]}"
      return nil
    end

    remote_player
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
