class CreatePlayerGamesStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :player_games_statistics do |t|
      t.references :player_statistic, null: false, foreign_key: true
      t.integer :appearances
      t.integer :lineups
      t.integer :minutes
      t.integer :number
      t.string :position
      t.float :rating
      t.boolean :captain

      t.timestamps
    end
  end
end
