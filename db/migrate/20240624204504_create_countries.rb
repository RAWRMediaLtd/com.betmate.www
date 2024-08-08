class CreateCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :countries do |t|
      t.string :name, null: false
      t.string :code
      t.string :flag
      t.string :slug, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
