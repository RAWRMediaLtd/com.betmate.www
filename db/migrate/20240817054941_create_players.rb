class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :firstname
      t.string :lastname
      t.integer :age
      t.date :birth_date
      t.string :birth_place
      t.string :birth_country
      t.string :nationality
      t.string :height
      t.string :weight
      t.boolean :injured
      t.string :photo

      t.timestamps
    end
  end
end
