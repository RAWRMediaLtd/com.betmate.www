class AddLastSyncedAtToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :last_synced_at, :datetime
  end
end
