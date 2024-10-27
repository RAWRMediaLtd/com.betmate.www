class RenameTypeColumnInFixtureEvents < ActiveRecord::Migration[7.1]
  def change
    rename_column :fixture_events, :type, :event_type
  end
end
