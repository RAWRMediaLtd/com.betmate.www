class SeasonsController < ApplicationController
	before_action :set_league, only: [:index, :show, :refresh]

  def index
		@seasons = @league.seasons

		puts @seasons
  end

  def show
  	@season = @league.seasons.find(params[:id])
  end

  def refresh

  end

	private

	def set_league

		@league = League.find_by!(slug: params[:league_slug])
	end
end
