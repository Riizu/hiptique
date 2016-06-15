require "rails_helper"

RSpec.feature "user sees retired item" do
  scenario "they view a retired item" do
    item = create(:item, status: 1)

    visit item_path(item)

    expect(page).to have_content("Item Retired")
    expect(page).not_to have_content("Add to Cart")
  end
end
