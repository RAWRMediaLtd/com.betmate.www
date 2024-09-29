class CreatePlayerFoulsStatistcs < ActiveRecord::Migration[7.1]
  def change
    create_table :player_fouls_statistcs do |t|
      t.integer :drawn
      t.integer :committed
      t.references :player_statistic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
