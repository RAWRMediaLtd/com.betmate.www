class CreateApiUsages < ActiveRecord::Migration[7.1]
  def change
    create_table :api_usages do |t|
      t.date :last_reset
      t.integer :usage
      t.integer :limit

      t.timestamps
    end
  end
end
