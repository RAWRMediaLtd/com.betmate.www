class CreateStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :statuses do |t|
      t.string :long
      t.string :short
      t.integer :elapsed
			t.references :fixture, null: false, foreign_key: true

      t.timestamps
    end
  end
end
