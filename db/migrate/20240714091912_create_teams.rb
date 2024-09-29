class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :code
      t.references :country, null: true, foreign_key: true
      t.integer :founded
      t.boolean :national
      t.string :logo

      t.timestamps
    end
  end
end
