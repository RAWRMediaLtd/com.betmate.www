class PlayerCardsStatistic < ApplicationRecord
  belongs_to :player_statistic

  def self.find_or_initialize_and_update(cards_data, player_statistic)
    cards_stat = PlayerCardsStatistic.find_or_initialize_by(player_statistic: player_statistic)

    if cards_stat.new_record? || cards_stat.updated?(cards_data)
      cards_stat.assign_attributes(
        yellow: cards_data['yellow'],
        yellowred: cards_data['yellowred'],
        red: cards_data['red'],
        last_synced_at: Time.now
      )
    end
    cards_stat.save!
  end

  def updated?(cards_data)
    yellow != cards_data['yellow'] ||
    yellowred != cards_data['yellowred'] ||
    red != cards_data['red']
  end
end
