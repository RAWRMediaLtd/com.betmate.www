class FixtureEvent < ApplicationRecord
  belongs_to :team
  belongs_to :player
  belongs_to :assist, class_name: 'Player', optional: true
  belongs_to :fixture

  def self.fetch_from_api(params = {})
    api_client = ApiClient.new
    remote_fixture_events = api_client.fetch('fixtures/events', params)

    remote_fixture_events.each do |remote_fixture_event|
      find_or_initialize_and_update(remote_fixture_event, params[:fixture])
    end
  end

  def self.find_or_initialize_and_update(event_data, fixture)
    puts "Event data: #{event_data}"
    puts "Team: #{event_data['team']}"
    fixture = Fixture.find_by_id(fixture)
    team = Team.find_or_initialize_by(id: event_data['team']['id'])
    player = Player.find_or_initialize_by(id: event_data['player']['id'])
    assist_player = Player.find_or_initialize_by(id: event_data['assist']['id'])

    event = FixtureEvent.find_or_initialize_by(
      fixture: fixture,
      time_elapsed: event_data['time']['elapsed'],
      time_extra: event_data['time']['extra'],
      team: team,
      player: player,
      assist: assist_player,
      event_type: event_data['type'],
      detail: event_data['detail']
    )

    if event.new_record?
      Rails.logger.info "Creating fixture event: #{event_data}"
      puts "Creating fixture event: #{event_data}"

      event.assign_attributes(
        comments: event_data['comments']
      )
    else
      Rails.logger.info "Updating fixture event: #{event_data}"
      puts "Updating fixture event: #{event_data}"

      event.update(
        comments: event_data['comments']
      )
    end
    begin
      event.save!
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Failed to save fixture event: #{e.message}"
      puts "Failed to save fixture event: #{e.message}"
      raise
    end

    event
  end

  def updated?(event_data)
    assist != event_assist_player ||
    comments != event_data['comments']
  end
end
