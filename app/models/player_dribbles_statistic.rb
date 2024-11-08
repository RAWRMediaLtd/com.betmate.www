class PlayerDribblesStatistic < ApplicationRecord
  belongs_to :player_statistic

  def self.find_or_initialize_and_update(dribbles_data, player_statistic)
    dribbles_stat = PlayerDribblesStatistic.find_or_initialize_by(player_statistic: player_statistic)

    if dribbles_stat.new_record? || dribbles_stat.updated?(dribbles_data)
      dribbles_stat.assign_attributes(
        attempts: dribbles_data['attempts'],
        succes: dribbles_data['success'],
        past: dribbles_data['past'],
        last_synced_at: Time.now
      )
    end

    dribbles_stat.save!
  end

  def updated?(dribbles_data)
    attempts != dribbles_data['attempts'] ||
    success != dribbles_data['success'] ||
    past != dribbles_data['past']
  end

  dribbles_stat
end
