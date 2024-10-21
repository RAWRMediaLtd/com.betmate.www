class AddLastSyncedAtToFixtureStatuses < ActiveRecord::Migration[7.1]
  def change
    add_column :fixture_statuses, :last_synced_at, :datetime
  end
end
