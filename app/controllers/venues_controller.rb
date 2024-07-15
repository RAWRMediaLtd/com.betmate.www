class VenuesController < ApplicationController
  def index
		@venues = Venue.all
  end

  def show
		@venue = Venue.find_by!(slug: params[:slug])
  end

  def refresh
		Venue.fetch_and_update_from_api

		@venues = Venue.all
		respond_to do |format|
			format.html {
				render partial: 'venues_list', locals: {
					venues: @venues
				}
			}
		end
	end
end
