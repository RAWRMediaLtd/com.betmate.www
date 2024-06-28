class LeaguesController < ApplicationController
  def index
		@leagues = League.all
  end

  def show
  end

  def refresh
  	fetch_and_update_leagues
		@leagues = League.all

		respond_to do |format|
			format.js {
				render partial: 'leagues_list', locals: {
					leagues: @leagues
				}
			}
		end
	end

	private


end
