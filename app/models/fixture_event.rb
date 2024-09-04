class FixtureEvent < ApplicationRecord
  belongs_to :team
  belongs_to :player
  belongs_to :assist, class_name: 'Player', optional: true
  belongs_to :fixture

  @event_assist_player = nil

  def self.find_or_initialize_and_update(event_data, fixture)
    event_player = Player.find_or_initialize_by(id: event_data['player']['id'])
    @event_assist_player = Player.find_or_initialize_by(id: event_data['assist']['id'])

    event = FixtureEvent.find_or_initialize_by(
      fixture:,
      time_elapsed: event_data['time']['elapsed'],
      time_extra: event_data['time']['extra'],
      team: Team.find_or_initialize_and_update(id: event_data['team']['id']),
      player: event_player,
      assist: @event_assist_player,
      event_type: event_data['type'],
      detail: event_data['detail']
    )

    if event.new_record? || event.updated?(event_data)
      event.assign_attributes(
        comments: event_data('comments')
      )
      event.save!
    end

    event
  end

  def updated?(event_data)
    assist != @event_assist_player ||
      comments != event_data['comments']
  end
end
