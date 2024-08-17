class CreateFixturePeriods < ActiveRecord::Migration[7.1]
  def change
    create_table :fixture_periods do |t|
      t.integer :first_half
      t.integer :second_half
      t.references :fixture, null: false, foreign_key: true

      t.timestamps
    end
  end
end
