class CreateFixtures < ActiveRecord::Migration[7.1]
  def change
    create_table :fixtures do |t|
      t.string :referee
      t.string :timezone
      t.datetime :date
      t.integer :timestamp
      t.references :status, null: true, foreign_key: true
      t.references :venue, null: true, foreign_key: true
      t.references :home_team, null: false, foreign_key: { to_table: :teams }
      t.references :away_team, null: false, foreign_key: { to_table: :teams }
      # t.references :league, null: false, foreign_key: true
      t.references :season, null: false, foreign_key: true
      t.string :round

      t.timestamps
    end
  end
end
