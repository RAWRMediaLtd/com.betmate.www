class AddLastSyncedToLeagues < ActiveRecord::Migration[7.1]
  def change
    add_column :leagues, :last_synced_at, :datetime
  end
end
