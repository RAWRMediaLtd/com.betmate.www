class CreatePlayerCardsStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :player_cards_statistics do |t|
      t.integer :yellow
      t.integer :yellored
      t.integer :red
      t.references :player_statistic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
