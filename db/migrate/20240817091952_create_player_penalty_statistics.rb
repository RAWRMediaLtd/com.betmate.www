class CreatePlayerPenaltyStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :player_penalty_statistics do |t|
      t.integer :won
      t.integer :committed
      t.integer :scored
      t.integer :missed
      t.integer :saved
      t.references :player_statistic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
