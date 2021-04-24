require 'rails_helper'

RSpec.describe 'Bulk Discount Show page' do
  before :each do
    @merchant = create(:merchant)
    @discount_1 = create(:bulk_discount, merchant: @merchant)
    visit "/merchant/#{@merchant.id}/bulk_discounts/#{@discount_1.id}"
  end

  describe 'When I visit a discounts show page' do
    it 'can see discount percentage and minimum quantity' do
      expect(page).to have_content((@discount_1.percentage * 100).to_i)
      expect(page).to have_content(@discount_1.minimum_quantity)
    end
  end
end
