class PlayerFoulsStatistc < ApplicationRecord
  belongs_to :player_statistic

  def self.find_or_initialize_and_update(fouls_data, player_statistic)
    fouls_stat = PlayerFoulsStatistc.find_or_initialize_by(player_statistic: player_statistic)

    if fouls_stat.new_record? || fouls_stat.updated?(fouls_data)
      fouls_stat.assign_attributes(
        drawn: fouls_data['drawn'],
        committed: fouls_data['committed'],
        last_synced_at: Time.now
      )
    end
    fouls_stat.save!
  end

  def updated?(fouls_data)
    drawn != fouls_data['drawn'] ||
    committed != fouls_data['committed']
  end

  fouls_stat
end
