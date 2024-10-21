class RenameTypeColumnInFixtureStatistics < ActiveRecord::Migration[7.1]
  def change
    rename_column :fixture_statistics, :type, :stat_type
  end
end
