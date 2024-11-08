class AddLastSyncedAtToPlayerStatistics < ActiveRecord::Migration[7.1]
  def change
    add_column :player_statistics, :last_synced_at, :datetime
    add_column :player_cards_statistics, :last_synced_at, :datetime
    add_column :player_dribbles_statistics, :last_synced_at, :datetime
    add_column :player_duels_statistics, :last_synced_at, :datetime

    rename_table :player_fouls_statistcs, :player_fouls_statistics
    add_column :player_fouls_statistics, :last_synced_at, :datetime
    add_column :player_games_statistics, :last_synced_at, :datetime
    add_column :player_goals_statistics, :last_synced_at, :datetime
    add_column :player_passes_statistics, :last_synced_at, :datetime
    add_column :player_penalty_statistics, :last_synced_at, :datetime
    add_column :player_shots_statistics, :last_synced_at, :datetime

    rename_table :player_substitues_statistics, :player_substitutes_statistics
    add_column :player_substitutes_statistics, :last_synced_at, :datetime
    add_column :player_tackles_statistics, :last_synced_at, :datetime
  end
end
