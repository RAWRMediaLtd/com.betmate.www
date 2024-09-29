class CreatePlayerPassesStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :player_passes_statistics do |t|
      t.integer :total
      t.integer :key
      t.integer :accuracy
      t.references :player_statistic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
