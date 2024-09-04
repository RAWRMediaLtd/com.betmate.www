class FixtureStatistic < ApplicationRecord
  belongs_to :fixture

  # Finds or initializes a statistic and then updates it
  def self.find_or_initialize_and_update(statistic_data, fixture)
    # Find or initialize by both fixture and type (assuming type is unique per
    # fixture)
    fixture = Fixture.find_by(fixture.id)
    statistic = fixture.statistics.find_or_initialize_by(
      type: statistic_data['type'],
      value: statistic_data['value']
    )

    if statistic.new_record? || statistic.statistic_updated?(statistic_data)
      statistic.assign_attributes(
        value: statistic_data['value'],
        fixture:
      )
      statistic.save!
    end
    statistic
  end

  # Checks if the statistic needs to be updated
  def statistic_updated?(statistic_data)
    value != statistic_data['value']
  end
end
