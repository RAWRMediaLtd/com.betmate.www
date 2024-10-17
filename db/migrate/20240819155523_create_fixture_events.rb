class CreateFixtureEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :fixture_events do |t|
      t.integer :time_elapsed
      t.boolean :time_extra
      t.references :team, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.references :assist, null: true, foreign_key: { to_table: "players" }
      t.string :type
      t.string :detail
      t.string :comments
      t.references :fixture, null: false, foreign_key: true

      t.timestamps
    end
  end
end
