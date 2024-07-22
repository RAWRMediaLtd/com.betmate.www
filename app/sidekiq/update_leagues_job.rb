class UpdateLeaguesJob
  include Sidekiq::Job

  def perform(country_id)
    # Do something
		country = Country.find(country_id)
		League.fetch_and_update_from_api(country)
  end
end
