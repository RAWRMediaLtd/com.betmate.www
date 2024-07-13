class CreateLeagues < ActiveRecord::Migration[7.1]
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :league_type
      t.string :logo
      t.references :country, null: false, foreign_key: true
			t.string :slug, null: false

      t.timestamps
    end
  end
end
