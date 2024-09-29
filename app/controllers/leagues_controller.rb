class LeaguesController < ApplicationController
	before_action :set_country, only: [:index, :show, :refresh]

  def index
		@leagues = @country ? @country.leagues : League.all
  end

  def show
		@league = @country.leagues.find_by!(slug: params[:slug])
  end

	def refresh

		League.fetch_and_update_from_api(@country)
		@leagues = @country ? @country.leagues : League.all

		respond_to do |format|
			format.html {
				if @country
					redirect_to country_leagues_path(@country.slug),
					notice: 'Leagues udpated sucessfully'
				else
					redirect_to leagues_path,
					notice: 'Leagues Updated successfully'
				end
			}
		end
	end

	private

	def set_country
		@country = Country.find_by!(slug: params[:country_slug]) if params[:country_slug]
	end
end
