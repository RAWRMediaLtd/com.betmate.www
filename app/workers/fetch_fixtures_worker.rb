class FetchFixturesWorker

	include Sidekiq::Worker

	def perform(season_id, remaining_calls)
	end
end
