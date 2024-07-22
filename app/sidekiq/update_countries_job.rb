class UpdateCountriesJob
  include Sidekiq::Job

  def perform
    # Do something
		Country.fetch_and_update_from_api
  end
end
