require 'rails_helper'

RSpec.describe 'Bulk Discount Edit Page' do
  before :each do
    @merchant = create(:merchant)
    @discount_1 = create(:bulk_discount, merchant: @merchant)
    visit "/merchant/#{@merchant.id}/bulk_discounts/#{@discount_1.id}/edit"
  end

  describe 'I click link to edit the discount from the show page' do
    it ' can see that the discounts current attributes are pre-poluated in the form' do
      expect(find_field('Percentage').value).to eq("#{@discount_1.percentage}")
      expect(find_field('Minimum quantity').value).to eq("#{@discount_1.minimum_quantity}")

      fill_in "Percentage", with: 0.15
      fill_in "Minimum quantity", with: 10
      click_button "Update Discount"

      expect(current_path).to eq("/merchant/#{@merchant.id}/bulk_discounts/#{@discount_1.id}")
      expect(page).to have_content("Discount: 15% off")
      expect(page).to have_content("Quantity Threshold: 10")
    end

    it 'shows error message if fields are blank' do
      fill_in "Percentage", with: ""
      fill_in "Minimum quantity", with: ""
      click_button "Update Discount"

      expect(page).to have_content("Please fill in all fields.")
      expect(page).to have_button('Update Discount')
    end
  end
end
