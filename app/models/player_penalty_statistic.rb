class PlayerPenaltyStatistic < ApplicationRecord
  belongs_to :player_statistic

  def self.find_or_initialize_and_update(penalty_data, player_statistic)
    penalty_statistic = PlayerPenaltyStatistic.find_or_initialize_by(player_statistic: player_statistic)

    if penalty_statistic.new_record? || penalty_statistic.updated?(penalty_data)
      penalty_statistic.assign_attributes(
        won: penalty_data['won'],
        committed: penalty_data['commited'],
        scored: penalty_data['scored'],
        missed: penalty_data['missed'],
        saved: penalty_data['saved'],
        last_synced_at: Time.now
      )
    end

    penalty_statistic.save!
  end

  def updated?(penalty_data)
    won != penalty_data['won'] ||
    committed != penalty_data['commited'] ||
    scored != penalty_data['scored'] ||
    missed != penalty_data['missed'] ||
    saved != penalty_data['saved']
  end
end
