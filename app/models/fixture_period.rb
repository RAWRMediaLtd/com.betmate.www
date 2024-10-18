class FixturePeriod < ApplicationRecord
  belongs_to :fixture

  def self.find_or_initialize_and_update(period_data, fixture)

		#puts "Period: #{period_data}"
		#puts "Fixture: #{fixture}"

		period = fixture.period || fixture.build_period

		#puts "PERIOD: Fixture - #{fixture.id}"

		if period.new_record? || period.period_updated?(period_data)
			period.assign_attributes(
				first_half: period_data['first'],
				second_half: period_data['second'],
				fixture: fixture
			)
			period.save!
		end
		period
	end

	def period_updated?(period_data)
		first_half != period_data['first'] ||
		second_half != period_data['second']
	end
end
