class AddLastSyncedAtToFixtures < ActiveRecord::Migration[7.1]
  def change
    add_column :fixtures, :last_synced_at, :datetime
  end
end
