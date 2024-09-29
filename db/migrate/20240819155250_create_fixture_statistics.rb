class CreateFixtureStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :fixture_statistics do |t|
      t.string :type
      t.integer :value
      t.references :fixture, null: false, foreign_key: true

      t.timestamps
    end
  end
end
