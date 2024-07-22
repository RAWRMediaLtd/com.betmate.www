class UpdateFixturesJob
  include Sidekiq::Job

  def perform(season_id)
    # Do something
		season = Season.find(season_id)
		Fixture.fetch_and_update_from_api(season.league)
  end
end
