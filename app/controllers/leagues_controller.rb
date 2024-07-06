class LeaguesController < ApplicationController
  def index
		@leagues = League.all
    @country = League.country
  end

  def show
		@league = League.find(params[:id])
  end

	def refresh
		League.fetch_and_update_from_api
		@leagues = League.all

		respond_to do |format|
			format.js {
				render partial: 'leagues_list', locals: {
					leagues: @leagues
				}
			}
			format.html {
				redirect_to leagues_path
			}
		end
	end
end
