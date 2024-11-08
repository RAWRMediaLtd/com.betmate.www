class PlayerGamesStatistic < ApplicationRecord
  belongs_to :player_statistic

  def self.find_or_initialize_and_update(games_data, player_statistic)
    games_statistic = PlayerGamesStatistic.find_or_initialize_by(player_statistic: player_statistic)

    if games_statistic.new_record? || games_statistic.updated?(games_data)
      games_statistic.assign_attributes(
        appearances: games_data['appearances'],
        lineups: games_data['lineups'],
        minutes: games_data['minutes'],
        number: games_data['number'],
        position: games_data['position'],
        rating: games_data['rating'],
        captain: games_data['captain'],
        last_synced_at: Time.now
      )
    end
    games_statistic.save!
  end

  def updated?(games_data)
    appearences != games_data['appearances'] ||
    lineups != games_data['lineups'] ||
    minutes != games_data['minutes'] ||
    number != games_data['number'] ||
    position != games_data['position'] ||
    rating != games_data['rating'] ||
    captain != games_data['captain']
  end
end
