Then(/^I set (.*) filter to (.*)$/) do |filter, value|
  case filter
  when 'Baths'
    @search_page.set_baths(value)
  when 'Property Type'
    @search_page.toggle_property_type(value)
  when /(\w{3})imum (.*)/
    @search_page.set_limit_filter($2.downcase, $1.downcase, value)
  else
    abort 'Unknown filter type'
  end
end

And(/^I verify in search results (.*) (?:is|are) (greater|less) than or equal to (.*)$/) do |type, operator, value|
  expect(@search_page.results_valid?(type, operator, value)).to eq true
end