class CreateFixtureScores < ActiveRecord::Migration[7.1]
  def change
    create_table :fixture_scores do |t|
      t.integer :halftime_home
      t.integer :halftime_away
      t.integer :fulltime_home
      t.integer :fulltime_away
      t.integer :extratime_home
      t.integer :extratime_away
      t.integer :penalty_home
      t.integer :penalty_away
      t.references :fixture, null: false, foreign_key: true

      t.timestamps
    end
  end
end
