class Status < ApplicationRecord
	belongs_to :fixture

	def self.find_or_initialize_and_update(status_data, fixture)

		status = fixture.status || fixture.build_status

		puts "STATUS: Fixture - #{fixture.id}"

		if status.new_record? || status.status_updated?(status_data)
			status.assign_attributes(
				long: status_data['long'],
				short: status_data['short'],
				elapsed: status_data['elapsed'],
				fixture: fixture
			)
			status.save!
		end
		status
	end

	def status_updated?(status_data)
		long != status_data['long'] ||
		short != status_data['short'] ||
		elapsed != status_data['elapsed']
	end
end
