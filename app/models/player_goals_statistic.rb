class PlayerGoalsStatistic < ApplicationRecord
  belongs_to :player_statistic

  def self.find_or_initialize_and_update(goals_data, player_statistic)
    goals_statistic = PlayerGoalsStatistic.find_or_initialize_by(player_statistic: player_statistic)

    if goals_statistic.new_record? || goals_statistic.updated?(goals_data)
      goals_statistic.assign_attributes(
        total: goals_data['total'],
        conceded: goals_data['conceded'],
        assists: goals_data['assists'],
        saves: goals_data['saves'],
      )
    end

    goals_statistic.save!
  end

  def updated?(goals_data)
    total != goals_data['total'] ||
    conceded != goals_data['conceded'] ||
    assists != goals_data['assists'] ||
    saves != goals_data['saves']
  end
end
