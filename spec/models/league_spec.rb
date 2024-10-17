require 'rails_helper'

RSpec.describe League, type: :model do
	describe '.create_or_update' do
		it 'creates a new league if it does not exist' do
			country = Country.create!(name: 'England', code: 'EN', flag: 'flag_url')
			league_data = { 'id' => 1, 'name' => 'Premier League' }
      seasons = [{
        'year' => 2024,
        'start' => '2024-08-01',
        'end' => '2024-05-31',
        'current' => true,
        "coverage" => {
          "fixtures" => {
            "events" => true,
            "lineups" => true,
            "statistics_fixtures" => true,
            "statistics_players" => true
          },
          "standings" => true,
          "players" => true,
          "top_scorers" => true,
          "top_assists" => true,
          "top_cards" => true,
          "injuries" => true,
          "predictions" => true,
          "odds" => true
        }
      }]
			league = League.create_or_update(league_data, country)
			expect(league).to be_persisted
    end
  end
end
