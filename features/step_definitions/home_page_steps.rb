Given(/^I am on the Redfin homepage$/) do
  @home_page = Home.new
  @home_page.load
  expect(page.title).to eq 'Real Estate, Homes for Sale, MLS Listings, Agents | Redfin'
end

And(/^I search for homes in (.*)$/) do |location|
  @home_page.location_search(location)
  @search_page = SearchPage.new
  @search_page.page_loaded?
end