class PlayerPassesStatistic < ApplicationRecord
  belongs_to :player_statistic

  def self.find_or_initialize_and_update(passes_data, player_statistic)
    passes_statistic = PlayerPassesStatistic.find_or_initialize_by(player_statistic: player_statistic)

    if passes_statistic.new_record? || passes_statistic.updated?(passes_data)
      passes_statistic.assign_attributes(
        total: passes_data['total'],
        key: passes_data['key'],
        accuracy: passes_data['accuracy'],
      )
    end

    passes_statistic.save!
  end

  def updated?(passes_data)
    total != passes_data['total'] ||
    key != passes_data['key'] ||
    accuracy != passes_data['accuracy']
  end
end
