class CreateLeagues < ActiveRecord::Migration[7.1]
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :type
      t.string :logo
      t.references :country, null: false, foreign_key: true

      t.timestamps
    end
  end
end
