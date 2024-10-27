class FixtureStatistic < ApplicationRecord
  belongs_to :fixture
  belongs_to :team

  def self.fetch_from_api(params = {})
    api_client = ApiClient.new
    remote_fixture_statistics = api_client.fetch('fixtures/statistics', params)

    puts "Remote fixture statistics: #{remote_fixture_statistics.length}"

    remote_fixture_statistics.each do |remote_fixture_statistic|
      team_data = remote_fixture_statistic['team']
      team = Team.find_or_create_by(id: team_data['id']) do |t|
        t.id = team_data['id']
        t.name = team_data['name']
      end

      remote_fixture_statistic['statistics'].each do |statistic|
        create_or_update(statistic, team, params[:fixture])
      end
    end
  end

  def self.create_or_update(fixture_statistic_data, team, fixture_id)
    Rails.logger.info "Creating or updating fixture statistic: #{fixture_statistic_data}"

    fixture = Fixture.find_by(id: fixture_id)

    statistic = FixtureStatistic.find_or_initialize_by(
      fixture: fixture,
      stat_type: fixture_statistic_data['type']
    )

    if statistic.new_record?
      Rails.logger.info "Creating fixture statistic: #{fixture_statistic_data}"
      puts "Creating fixture statistic: #{fixture_statistic_data}"
      statistic.assign_attributes(
        value: fixture_statistic_data['value'],
        half: fixture_statistic_data['half'],
        team: team,
        last_synced_at: Time.now
      )
    else
      Rails.logger.info "Updating fixture statistic: #{fixture_statistic_data}"
      puts "Updating fixture statistic: #{fixture_statistic_data}"
      statistic.update(
        value: fixture_statistic_data['value'],
        half: fixture_statistic_data['half'],
        last_synced_at: Time.now
      )
    end

    begin
      statistic.save!
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to save fixture statistic: #{e.message}"
      puts "Failed to save fixture statistic: #{e.message}"
      raise
    end

    statistic
  end
end
