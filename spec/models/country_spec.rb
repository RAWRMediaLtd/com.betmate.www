require 'rails_helper'

RSpec.describe Country, type: :model do
  describe '.create_or_update_country' do
    let(:country_data_variations) do
      [
        { 'name' => 'New Zealand', 'code' => 'NZ', 'flag' => 'flag_url_1' },
        { 'name' => 'New-Zealand', 'code' => 'NZ', 'flag' => 'flag_url_2' },
        { 'name' => 'new zealand', 'code' => 'NZ', 'flag' => 'flag_url_3' }
      ]
    end

    it 'normalizes and updates country names correctly' do
      country_data_variations.each do |country_data|
        Country.create_or_update(country_data)
      end

      country = Country.find_by(name: 'New Zealand')
      expect(country).not_to be_nil
      expect(country.code).to eq('NZ')
      expect(country.flag).to eq('flag_url_3') # Assuming the last one should be the final update
    end
  end
end
