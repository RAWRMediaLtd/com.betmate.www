class PlayerDuelsStatistic < ApplicationRecord
  belongs_to :player_statistic

  def self.find_or_initialize_and_update(duels_data, player_statistic)
    duels_stat = PlayerDuelsStatistic.find_or_initialize_by(player_statistic: player_statistic)

    if duels_stat.new_record? || duels_stat.updated?(duels_data)
      duels_stat.assign_attributes(
        total: duels_data['total'],
        won: duels_data['won'],
        last_synced_at: Time.now
      )
    end

    duels_stat.save!
  end

  def updated?
    total != duels_stat['total'] ||
    won != duels_stat['won']
  end
end
