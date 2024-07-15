class CreateSeasons < ActiveRecord::Migration[7.1]
	def change
		create_table :seasons do |t|
			t.integer :year
			t.date :start
			t.date :end
			t.boolean :current
			t.json :coverage
			t.string :slug
			t.references :league, null: false, foreign_key: true

			t.timestamps
		end
	end
end
