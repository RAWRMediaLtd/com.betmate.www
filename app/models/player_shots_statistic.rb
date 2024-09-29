class PlayerShotsStatistic < ApplicationRecord
  belongs_to :player_statistic

  def self.find_or_initialize_and_update(shots_data, player_statistic)
    shots_statistic = PlayerShotsStatistic.find_or_initialize_by(player_statistic: player_statistic)

    if shots_statistic.new_record? || shots_statistic.updated?(shots_data)
      shots_statistic.assign_attributes(
        total: shots_data['total'],
        on: shots_data['on']
      )
    end
    shots_statistic.save!
  end

  def updated?(shots_data)
    total != shots_data['total'] ||
    on != shots_data['on']
  end
end
