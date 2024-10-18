require 'rails_helper'

RSpec.describe Venue, type: :model do
	describe '.find_or_create' do
		it 'creates a new venue if it does not exist' do
			venue_data = { 'id' => 1, 'name' => "test'O", 'country' => 'test' }
			Venue.find_or_create(venue_data)
			expect(Venue.find_by(id: 1)).to be_present
		end
	end

	describe '.sanitize_name' do
		it 'sanitizes the name' do
			expect(Venue.sanitize_name("test'O")).to eq("test-O")
		end
	end

	describe 'slug generation' do
    it 'generates a slug for a venue with non-Latin characters' do
      venue = Venue.create(name: 'Стадион ФКСушица', address: 'Some address', city: 'Some city', capacity: 1000, surface: 'grass', image: 'some_image_url')
      expect(venue.slug).to eq('стадион-фксушица')
    end
  end
end
