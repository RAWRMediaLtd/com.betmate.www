class SeasonsController < ApplicationController
	before_action :set_league, only: [:index, :show, :refresh]

  def index
		@seasons = @league.season
  end

  def show
  	@season = @league.seasons.find(params[:id])
  end

  def refresh

  end

	private

	def set_league
		@league = League.find(params[:league_slug])
	end
end
