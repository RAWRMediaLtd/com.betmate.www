class CreatePlayerDribblesStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :player_dribbles_statistics do |t|
      t.integer :attempts
      t.integer :success
      t.integer :past
      t.references :player_statistic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
