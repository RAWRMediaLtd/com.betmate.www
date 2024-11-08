class PlayerSubstituesStatistic < ApplicationRecord
  belongs_to :player_statistic

  def self.find_or_initialize_and_update(substitutes_data, player_statistic)
    substitutes_statistic = PlayerSubstitutesStatistic.find_or_initialize_by(player_statistic: player_statistic)

    if substitutes_statistic.new_record? || substitutes_statistic.updated?(substitutes_data)
      substitutes_statistic.assign_attributes(
        self_in: substitutes_data['in'],
        out: substitutes_data['out'],
        bench: substitutes_data['bench'],
        last_synced_at: Time.now
      )
    end

    substitutes_statistic.save!
  end

  def updated?(substitutes_data)
    self_in != substitutes_data['in'] ||
    out != substitutes_data['out'] ||
    bench != substitutes_data['bench']
  end

  def self_in=(value)
    self[:in] = value
  end
end
