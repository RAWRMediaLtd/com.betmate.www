class AddTeamToFixtureStatistics < ActiveRecord::Migration[7.1]
  def change
    add_reference :fixture_statistics, :team, null: false, foreign_key: true
  end
end
