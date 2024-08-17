class CreatePlayerStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :player_statistics do |t|
      t.references :player, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.references :season, null: false, foreign_key: true

      t.timestamps
    end
  end
end
