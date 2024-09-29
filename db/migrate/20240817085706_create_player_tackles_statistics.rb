class CreatePlayerTacklesStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :player_tackles_statistics do |t|
      t.integer :total
      t.integer :blocks
      t.integer :interceptions
      t.references :player_statistic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
