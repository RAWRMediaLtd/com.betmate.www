class AddWinnerToFixtures < ActiveRecord::Migration[7.1]
  def change
    add_column :fixtures, :winner, :string
  end
end
