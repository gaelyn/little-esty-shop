require 'rails_helper'

RSpec.describe 'Create new discount page' do
  before :each do
    @merchant = create(:merchant)
    @discount = create(:bulk_discount, merchant: @merchant)
  end

  describe 'I click Create New Discount on index page' do
    it 'can submit a form to create a new discount' do
      visit "/merchant/#{@merchant.id}/bulk_discounts"
      click_link "Create New Discount"
      expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts/new")

      fill_in "Percentage", with: 0.50
      fill_in "Minimum quantity", with: 5
      click_button "Create Bulk discount"

      expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts")
      expect(page).to have_content("Percentage Discount: 50% off")
      expect(page).to have_content("Quantity Threshold: 5")
    end

    it 'cannot create discount unless all fields are filled in' do
      visit "/merchant/#{@merchant.id}/bulk_discounts/new"

      click_on "Create Bulk discount"
      expect(page).to have_content("Please fill in all fields. Percentage can't be blank, Minimum quantity can't be blank.")
      expect(page).to have_button('Create Bulk discount')
    end
  end
end
