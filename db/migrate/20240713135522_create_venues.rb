class CreateVenues < ActiveRecord::Migration[7.1]
  def change
    create_table :venues do |t|
      t.string :name
      t.string :address
      t.string :city
      t.integer :capacity
      t.string :surface
      t.string :image
			t.string :slug, null: false

      t.timestamps
    end
  end
end
