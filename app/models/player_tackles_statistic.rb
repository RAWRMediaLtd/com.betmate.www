class PlayerTacklesStatistic < ApplicationRecord
  belongs_to :player_statistic

  def self.find_or_initialize_and_update(tackles_data, player_statistic)
    tackles_statistic = PlayerTacklesStatistic.find_or_initialize_by(player_statistic: player_statistic)

    if tackles_statistic.new_record? || tackles_statistic.updated?(tackles_data)
      tackles_statistic.assign_attributes(
        total: tackles_data['total'],
        blocks: tackles_data['blocks'],
        interceptions: tackles_data['interceptions'],
        last_synced_at: Time.now
      )
    end

    tackles_statistic.save!
  end

  def updated?(tackles_data)
    total != tackles_data['total'] ||
    blocks != tackles_data['blocks'] ||
    interceptions != tackles_data['interceptions']
  end
end
