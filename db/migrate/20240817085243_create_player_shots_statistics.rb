class CreatePlayerShotsStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :player_shots_statistics do |t|
      t.integer :total
      t.integer :on
      t.references :player_statistic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
