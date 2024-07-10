class SeasonsController < ApplicationController
	before_action :set_league, only: [:index, :show, :refresh]

  def index
		@seasons = @league.season
  end

  def show
  	@season = @league.seasons.find(params[:id])
  end

  def refresh
		Season.fetch_and_update_from_api(@league)
		@seasons = @league.seasons

		respond_to do |format|
			format.html { redirect_to league_seasons_path(@league), notice: 'Seasons updated successfully' }
		end
  end

	private

	def set_league
		@league = League.find(params[:league_id])
	end
end
