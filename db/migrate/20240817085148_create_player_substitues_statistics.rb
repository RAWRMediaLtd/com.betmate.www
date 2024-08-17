class CreatePlayerSubstituesStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :player_substitues_statistics do |t|
      t.integer :in
      t.integer :out
      t.integer :bench
      t.references :player_statistic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
