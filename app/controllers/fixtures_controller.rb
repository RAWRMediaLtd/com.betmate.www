class FixturesController < ApplicationController
	before_action :set_country
	before_action :set_league
	before_action :set_season

  def index
		@fixtures = @season.fixtures.order(round: :asc, date: :asc).group_by { |fixture| fixture.date.to_date }
  end

  def show
		@fixture = @season.fixtures.find(params[:id])
  end

  def refresh
		Fixture.fetch_and_update_from_api(@season)
		@fixtures = @season.fixtures.order(date: :asc).group_by { |fixture| fixture.date.to_date }

		respond_to do |format|
			format.html { redirect_to country_league_season_fixtures_path(@country.slug, @league.slug, @season.slug), notice: "Fixtures updated successfully" }
		end
	end

	private

	def set_country
		@country = Country.find_by!(slug: params[:country_slug])
	end

	def set_league
		@league = @country.leagues.find_by!(slug: params[:league_slug])
	end

	def set_season
		@season = @league.seasons.find_by!(slug: params[:season_slug])
	end
end
