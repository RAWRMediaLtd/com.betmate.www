class FixtureScore < ApplicationRecord
  belongs_to :fixture

	def self.find_or_initialize_and_update(score_data, fixture)

		score = fixture.score || fixture.build_score

		puts "SCORE: Fixture - #{fixture.id}"

		if score.new_record? || score.score_updated?(score_data)
			score.assign_attributes(
				halftime_home: score_data['halftime']['home'],
        halftime_away: score_data['halftime']['away'],
				fulltime_home: score_data['fulltime']['home'],
        fulltime_away: score_data['fulltime']['away'],
        extratime_home: score_data['extratime']['home'],
        extratime_away: score_data['extratime']['away'],
        penalty_home: score_data['penalty']['home'],
				penalty_away: score_data['penalty']['away'],
				fixture: fixture
			)
			score.save!
		end
		score
	end

	def score_updated?(score_data)
    halftime_home != score_data['halftime']['home'] ||
    halftime_away != score_data['halftime']['away'] ||
    fulltime_home != score_data['fulltime']['home'] ||
    fulltime_away != score_data['fulltime']['away'] ||
    extratime_home != score_data['extratime']['home'] ||
    extratime_away != score_data['extratime']['away'] ||
    penalty_home != score_data['penalty']['home'] ||
    penalty_away != score_data['penalty']['away']
	end
end
