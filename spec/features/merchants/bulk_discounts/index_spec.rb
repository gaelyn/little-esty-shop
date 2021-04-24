require 'rails_helper'

RSpec.describe 'Bulk Discount Index Page' do
  before :each do
    @merchant = create(:merchant)
    @discount_1 = create(:bulk_discount, merchant: @merchant)
    visit "/merchant/#{@merchant.id}/bulk_discounts"
  end

  describe 'I visit the discount index page' do
    it 'can see all of my bulk discounts including percentage and quantity threshold' do
      expect(page).to have_content((@discount_1.percentage * 100).to_i)
      expect(page).to have_content(@discount_1.minimum_quantity)
    end

    it 'can see link to each discounts show page' do
      within("#discount-#{@discount_1.id}") do
        expect(page).to have_link("See Discount", href: "/merchant/#{@merchant.id}/bulk_discounts/#{@discount_1.id}")
      end
    end
  end
end
