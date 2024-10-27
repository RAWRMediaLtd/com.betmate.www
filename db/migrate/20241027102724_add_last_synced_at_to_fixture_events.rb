class AddLastSyncedAtToFixtureEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :fixture_events, :last_synced_at, :datetime
  end
end
