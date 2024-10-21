class AddLastSyncedAtToFixtureStatistics < ActiveRecord::Migration[7.1]
  def change
    add_column :fixture_statistics, :last_synced_at, :datetime
  end
end
