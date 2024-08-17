class CreatePlayerGoalsStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :player_goals_statistics do |t|
      t.integer :total
      t.integer :conceded
      t.integer :assists
      t.integer :saves
      t.references :player_statistic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
