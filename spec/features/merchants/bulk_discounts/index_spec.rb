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

    it 'can see upcoming holidays header' do
      expect(page).to have_content(HolidayService.get_holidays[0])
      expect(page).to have_content(HolidayService.get_holidays[1])
      expect(page).to have_content(HolidayService.get_holidays[2])
    end

    it 'can see link to create a new discount' do
      expect(page).to have_link("Create New Discount", href: "/merchant/#{@merchant.id}/bulk_discounts/new")
      click_link('Create New Discount')
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant.id))
    end
  end
end
