class ChangePlayerCardsStatisticsColumnsToAllowNull < ActiveRecord::Migration[8.0]
  def change
		change_column :player_cards_statistics, :yellow, :integer, null: true
		change_column :player_cards_statistics, :yellowred, :integer, null: true
		change_column :player_cards_statistics, :red, :integer, null: true
  end
end
