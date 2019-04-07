class Home < SitePrism::Page

  set_url 'http://www.redfin.com'

  def location_search(location)
    within('div#tabContentId0') do
      fill_in 'search-box-input', with: location
      click_on 'Search'
    end
  end

end