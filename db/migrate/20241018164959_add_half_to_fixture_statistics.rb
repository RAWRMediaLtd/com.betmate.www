class AddHalfToFixtureStatistics < ActiveRecord::Migration[7.1]
  def change
    add_column :fixture_statistics, :half, :boolean, :default => false
  end
end
